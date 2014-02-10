module HalfAndHalf
  
  class Event
    attr_accessor :name, :variant

    def initialize(args={})
      @name = args[:name]
      @variant = args[:variant]
    end

    def experiment
      variant.experiment
    end

    def count
      Redis.current.bitcount(['halfandhalf', experiment.name, variant.name, name].join("."))
    end

    def conversion_rate
      count.to_f / experiment.sample_size
    end

    def significant?
      experiment.sample_size >= count_needed
    end

    def count_needed
      if effect == 0
        Float::INFINITY
      else
        (16 * variance / (effect ** 2)).to_i
      end
    end

    private

    def variance
      control_conversion_rate * (1 - control_conversion_rate)
    end

    def effect
      (conversion_rate - control_conversion_rate).abs
    end

    def control_conversion_rate
      control_event.conversion_rate
    end

    def control_event
      experiment.control.get_event(name)
    end
  end
end