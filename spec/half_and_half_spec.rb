require 'spec_helper'

describe HalfAndHalf do

  after(:each) do
    HalfAndHalf.instance_variable_set(:@experiments, [])
  end
  
  describe '#experiment' do

    it 'should create and add an experiment' do
      experiment = HalfAndHalf.experiment(:ab)
      experiment.should be_a(HalfAndHalf::Experiment)
      HalfAndHalf.experiments.should include(experiment)
    end
  end

  describe '#get_experiment' do

    it 'should return experiment with name' do
      experiment = HalfAndHalf.experiment(:ab)
      HalfAndHalf.get_experiment(:ab).should == experiment
    end
  end

  describe '#track_event' do

    it 'should track event in Redis' do
      experiment = HalfAndHalf.experiment :ab do |e|
        e.control 'control a'
        e.treatment 'treatment b'
      end
      trial = experiment.create_trial
      HalfAndHalf.track_event(:clicked, token: trial.token)
      Redis.current.bitcount('halfandhalf.ab.control.clicked').should == 1
    end
  end

  describe 'integration' do

    it 'should run sample experiment from readme' do
      experiment = HalfAndHalf.experiment :message_subject do |e|
        e.control ->(recipient) { "Hi!" }
        e.treatment ->(recipient) { "Hi, #{recipient.name}!" }, 
          name: :with_recipient_name
        e.events :delivered, :opened, :clicked
      end
      trials = 2000.times.map do
        trial = experiment.create_trial
        HalfAndHalf.track_event(:delivered, token: trial.token)
        trial
      end
      control_trials = trials.select do |trial|
        trial.variant == experiment.control
      end
      treatment_trials = trials.select do |trial|
        trial.variant == experiment.treatment
      end
      400.times do |i|
        HalfAndHalf.track_event(:opened, token: control_trials[i].token)
      end
      40.times do |i|
        HalfAndHalf.track_event(:clicked, token: control_trials[i].token)
      end
      500.times do |i|
        HalfAndHalf.track_event(:opened, token: treatment_trials[i].token)
      end
      50.times do |i|
        HalfAndHalf.track_event(:clicked, token: treatment_trials[i].token)
      end
      treatment_opened = experiment.treatment.get_event(:opened)
      treatment_opened.conversion_rate.should == 0.5
      treatment_opened.should be_significant
      treatment_clicked = experiment.treatment.get_event(:clicked)
      treatment_clicked.conversion_rate.should == 0.05
      treatment_clicked.should_not be_significant
    end
  end
end