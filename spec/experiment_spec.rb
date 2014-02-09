require 'spec_helper'

describe HalfAndHalf::Experiment do

  describe 'create_trial' do

    it 'should create trials with alternating variants' do
      experiment = HalfAndHalf::Experiment.new(name: :ab)
      experiment.control = HalfAndHalf::Control.new(result: 'control a')
      experiment.treatment = HalfAndHalf::Treatment.new(result: 'treatment b')
      experiment.create_trial.variant.should == experiment.control
      experiment.create_trial.variant.should == experiment.treatment
      experiment.create_trial.variant.should == experiment.control
    end
  end

  describe 'sample_size' do

    it 'should return ' do
      experiment = HalfAndHalf::Experiment.new(name: :ab)
      experiment.control = HalfAndHalf::Control.new(result: 'control a')
      experiment.treatment = HalfAndHalf::Treatment.new(result: 'treatment b')
      5.times do
        experiment.create_trial
      end
      experiment.sample_size.should == 2
    end
  end
end