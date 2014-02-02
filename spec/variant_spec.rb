require 'spec_helper'

describe HalfAndHalf::Variant do

  describe "call" do

    it 'should return value' do
      variant = HalfAndHalf::Variant.new(result: 'foo', name: :a)
      variant.call.should == 'foo'
    end

    it 'should return proc result' do
      variant = HalfAndHalf::Variant.new(result: ->(n) { n + 1 }, name: :a)
      variant.call(1).should == 2
    end
  end

  describe 'events' do

    it 'should return array of experiment events' do
      experiment = HalfAndHalf::Experiment.new(name: :foo, events: %w(delivered opened clicked))
      variant = HalfAndHalf::Variant.new(result: 'foo', name: :a, experiment: experiment)
      variant.events.map(&:name).should == %w(delivered opened clicked)
      variant.events.each do |event|
        event.should be_a(HalfAndHalf::Event)
      end
    end
  end

  describe "get_event" do

    it 'should return event' do
      experiment = HalfAndHalf::Experiment.new(name: :foo, events: %w(delivered opened clicked))
      variant = HalfAndHalf::Variant.new(result: 'foo', name: :a, experiment: experiment)
      event = variant.get_event(:clicked)
      event.should be_a(HalfAndHalf::Event)
      event.name.should == 'clicked'
      event.variant.should == variant
    end
  end

  describe "sample_size" do

    it 'should return count of first event' do
      experiment = HalfAndHalf::Experiment.new(name: :foo, events: %w(delivered opened clicked))
      variant = HalfAndHalf::Variant.new(result: 'foo', name: :a, experiment: experiment)
      event = variant.events.first
      event.should_receive(:count).and_return(20)
      variant.sample_size.should == 20
    end
  end
end