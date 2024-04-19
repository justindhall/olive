class Weather < ApplicationRecord
  self.abstract_class = true

  def self.get_weather_by_city(city_name:, state:, country_code:)
    city = City.find_or_create_by_name(name: city_name, state: state, country_code: country_code)
    OpenWeather::ForecastClient.new(city: city).get
  rescue Errors::BadRequestError, Errors::NotFoundError, Errors::RateLimitError, Errors::UnauthorizedError, Errors::ApiError => e
    OpenStruct.new(error_code: e.error_code, error_message: e.message)
  end
end
