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
      key = [experiment.name, variant.name, name].join(".")
      Redis.current.bitcount(key)
    end

    def conversion_rate
      count.to_f / variant.sample_size
    end

    def significant?
      count >= count_needed
    end

    def count_needed
      if effect != 0
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