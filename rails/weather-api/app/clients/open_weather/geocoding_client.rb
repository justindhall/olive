  module OpenWeather
    class GeocodingClient < BaseClient
      def initialize(city_name:, state:, country_code:)
        super()
        @city_name = city_name
        @state = state
        @country_code = country_code
      end

      def get
        response = super()
        data = JSON.parse(response.body)&.first
        ResponseObjects::CityResponse.new(
          city_name: data['name'],
          state: data['state'],
          country_code: data['country'],
          latitude: data['lat'],
          longitude: data['lon']
        )
      end

      private

      attr_accessor :city_name, :state, :country_code

      def url
        'http://api.openweathermap.org/geo/1.0/direct'
      end

      def params
        {
          q: "#{city_name},#{state},#{country_code}",
          limit: 1
        }
      end
    end
  end
