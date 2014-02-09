require 'spec_helper'

describe HalfAndHalf::Event do

  describe 'count' do

    it 'should return count from redis' do
      experiment = HalfAndHalf::Experiment.new(name: 'foo')
      variant = HalfAndHalf::Control.new(result: 'control a', experiment: experiment)
      experiment.control = variant
      event = HalfAndHalf::Event.new(name: :clicked, variant: variant)
      Redis.current.setbit('halfandhalf.foo.control.clicked', '1', 1)
      Redis.current.setbit('halfandhalf.foo.control.clicked', '2', 1)
      event.count.should == 2
    end
  end

  describe 'conversion rate' do

    it 'should return rate that converted from total trials' do
      experiment = HalfAndHalf::Experiment.new(name: 'foo')
      variant = HalfAndHalf::Control.new(result: 'control a', experiment: experiment)
      clicked = HalfAndHalf::Event.new(name: :clicked, variant: variant)
      clicked.should_receive(:count).and_return(1)
      experiment.should_receive(:sample_size).and_return(4)
      clicked.conversion_rate.should == 0.25
    end
  end

  describe 'significant?' do

    it 'should return true if count equal to required sample size' do
      experiment = HalfAndHalf::Experiment.new(name: 'foo')
      variant = HalfAndHalf::Control.new(result: 'control a', experiment: experiment)
      clicked = HalfAndHalf::Event.new(name: :clicked, variant: variant)
      experiment.should_receive(:sample_size).and_return(1000)
      clicked.should_receive(:count_needed).and_return(1000)
      clicked.should be_significant
    end

    it 'should return false if count less than required sample size' do
      experiment = HalfAndHalf::Experiment.new(name: 'foo')
      variant = HalfAndHalf::Control.new(result: 'control a', experiment: experiment)
      clicked = HalfAndHalf::Event.new(name: :clicked, variant: variant)
      experiment.should_receive(:sample_size).and_return(999)
      clicked.should_receive(:count_needed).and_return(1000)
      clicked.should_not be_significant
    end
  end

  describe 'count_needed' do

    it 'should return count needed for statistical significance' do
      clicked = HalfAndHalf::Event.new(name: :opened)
      clicked.stub(:control_conversion_rate).and_return(0.40)
      clicked.stub(:conversion_rate).and_return(0.50)
      clicked.count_needed.should == 384
    end

    it "should return infinity if effect is 0" do
      clicked = HalfAndHalf::Event.new(name: :opened)
      clicked.stub(:control_conversion_rate).and_return(0.50)
      clicked.stub(:conversion_rate).and_return(0.50)
      clicked.count_needed.should == Float::INFINITY
    end
  end
end