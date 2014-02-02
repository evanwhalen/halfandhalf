module HalfAndHalf

  class ExperimentBuilder
    attr_accessor :experiment

    def initialize(name, &block)
      @experiment = HalfAndHalf::Experiment.new(name: name)
      if block_given?
        block.call(self)
      end
    end

    def control(result, options={})
      experiment.control = HalfAndHalf::Control.new(
        options.merge(result: result, experiment: experiment)
      )
    end

    def treatment(result, options={})
      experiment.treatment = HalfAndHalf::Treatment.new(
        options.merge(result: result, experiment: experiment)
      )
    end

    def events(*events)
      experiment.events = events
    end

    def call
      experiment
    end
  end
end