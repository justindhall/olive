module OpenWeather
  class ForecastClient < BaseClient
    # OpenWeather recommends checking for new data every 10 minutes but this can be adjusted as needed
    EXPIRES_IN = 10.minutes

    def initialize(city:)
      super()
      @city = city
    end

    def get
      Rails.cache.fetch("#{city}_weather", expires_in: EXPIRES_IN) do
        response = super()
        handle_response(response)
      end
    end

    private

    attr_accessor :city

    def url
      'https://api.openweathermap.org/data/3.0/onecall'
    end

=begin
  OpenWeather returns a large amount of information that would likely be useful for a weather API. I'm sure that there
  would be uses for many of these things. For this exercise, I'm going to only work with current weather data, but this
  is written in a way that it should be easy to extend into minutely, hourly, daily, or alerts in the future. See the
  readme for some thoughts on how I would approach that.
=end
    def exclude
      'minutely,hourly,daily,alerts'
    end

    def params
      {
        lat: city.latitude,
        lon: city.longitude,
        units: 'imperial',
        exclude: exclude
      }
    end

    def handle_response(response)
      data = JSON.parse(response.body)
      response_obj = ResponseObjects::WeatherResponse.new(
        temperature: data.dig('current', 'temp'),
        humidity: data.dig('current', 'humidity'),
        wind_speed: data.dig('current', 'wind_speed'),
        conditions: data.dig('current', 'weather')&.first&.dig('description'),
        error_code: data.dig('cod'),
        error_message: data.dig('message')
      )
      if response_obj.error_code.present?
        handle_error(response_obj)
      else
        response_obj
      end
    end

    def handle_error(response_obj)
      log_error(
        class_name: self.class.name,
        error_message: response_obj.error_message,
        error_code: response_obj.error_code
      )
      case response_obj.error_code
      when '400'
        raise Errors::BadRequestError.new(response_obj.error_message, response_obj.error_code)
      when '401'
        raise Errors::UnauthorizedError.new(response_obj.error_message, response_obj.error_code)
      when '404'
        raise Errors::NotFoundError.new(response_obj.error_message, response_obj.error_code)
      when '429'
        raise Errors::RateLimitError.new(response_obj.error_message, response_obj.error_code)
      when /5\d{2}/
        raise Errors::ApiError.new(response_obj.error_message, response_obj.error_code)
      else
        raise StandardError
      end
    end
  end
end
