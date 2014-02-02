module HalfAndHalf

  class Trial
    attr_accessor :experiment, :variant, :number

    def initialize(args={})
      @experiment = args[:experiment]
      @variant = args[:variant]
      @number = args[:number]
    end

    def token
      [experiment.name, variant.name, number].join('.')
    end
  end
end