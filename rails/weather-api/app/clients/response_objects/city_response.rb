module ResponseObjects
  class CityResponse
    attr_accessor :city_name, :state, :country_code, :latitude, :longitude

    def initialize(city_name:, state:, country_code:, latitude:, longitude:)
      @city_name = city_name
      @state = state
      @country_code = country_code
      @latitude = latitude
      @longitude = longitude
    end
  end
end
