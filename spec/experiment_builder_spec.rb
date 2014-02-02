require 'spec_helper'

describe HalfAndHalf::ExperimentBuilder do

  describe 'call' do

    it 'should assign variants and events in block' do
      experiment = HalfAndHalf::ExperimentBuilder.new :ab do |e|
        e.control 'control a'
        e.treatment 'treatment b'
        e.events 'clicked'
      end.call
      experiment.control.call.should == 'control a'
      experiment.treatment.call.should == 'treatment b'
      experiment.events.should == %w(clicked)
    end
  end
end