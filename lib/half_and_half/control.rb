module HalfAndHalf

  class Control < Variant

    def default_name
      :control
    end

    def control?
      true
    end

    def treatment?
      false
    end
  end
end