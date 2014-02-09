module HalfAndHalf

  class Treatment < Variant

    def default_name
      :treatment
    end

    def control?
      false
    end

    def treatment?
      true
    end
  end
end