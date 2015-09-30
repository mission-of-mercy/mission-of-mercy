module Clinic
  extend self

  def location
    @location ||= begin
      if (location = ENV['LOCATION']).present?
        location
      else
        raise ArgumentError.new("Clinic location missing! Set environment var" +
                                " LOCATION")
      end
    end
  end
end
