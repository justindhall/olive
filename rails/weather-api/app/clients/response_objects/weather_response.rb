module ResponseObjects
  class WeatherResponse

=begin
   The purpose of these ResponseObjects to attempt to abstract the API specific things away from actually storing data
   with idea that it should make it easier to swap out APIs in the future. By using a WeatherResponse object instead of
   the raw JSON from OpenWeather, I can make sure that if I swap to using a different weather API, we only have to change
   the client class and everything downstream still works.

   That said, I don't have enough context to fully understand everything that might be helpful from a weather response.
   OpenWeather returns an enormous amount of information, so I'm going to make a few assumptions but it would be my
   expectation that this class would be expanded in the future with more business understanding. It's made in a way that
   it should be easily extensible so I don't think this is a problem for now.
=end

    attr_reader :temperature, :humidity, :wind_speed, :conditions, :error_code, :error_message

    def initialize(temperature:, humidity:, wind_speed:, conditions:, error_code: nil, error_message: nil)
      @temperature = temperature
      @humidity = humidity
      @wind_speed = wind_speed
      @conditions = conditions
      @error_code = error_code
      @error_message = error_message
    end
  end
end
