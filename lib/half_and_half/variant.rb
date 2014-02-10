module HalfAndHalf
  
  class Variant
    attr_accessor :name, :experiment

    def initialize(args={})
      @result = args[:result]
      @name = args[:name] || default_name
      @experiment = args[:experiment]
    end

    def default_name
      raise NotImplementedError
    end

    def control?
      raise NotImplementedError
    end

    def treatment?
      raise NotImplementedError
    end

    def call(*args)
      if @result.respond_to?(:call)
        @result.call(*args)
      else
        @result
      end
    end

    def events
      experiment.events.map do |name|
        HalfAndHalf::Event.new(
          name: name, 
          variant: self
        )
      end
    end

    def get_event(name)
      events.find do |event|
        event.name.to_sym == name.to_sym
      end
    end
  end
end