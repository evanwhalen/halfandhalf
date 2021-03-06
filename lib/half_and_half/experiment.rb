module HalfAndHalf
  
  class Experiment
    attr_accessor :name, :control, :treatment, :events

    def initialize(args={})
      @name = args[:name]
      @control = args[:control]
      @treatment = args[:treatment]
      @events = args[:events]
    end

    def create_trial
      number = Redis.current.incrby("halfandhalf.#{name}.trial_count", 1)
      variant = if number % 2 == 1
        control
      else
        treatment
      end
      HalfAndHalf::Trial.new(
        experiment: self,
        variant: variant,
        number: number
      )
    end

    def sample_size
      Redis.current.get("halfandhalf.#{name}.trial_count").to_i / 2
    end
  end
end