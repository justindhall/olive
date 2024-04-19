module OpenWeather
  class BaseClient
    def initialize
      @api_key = ENV['OPEN_WEATHER_API_KEY']
    end

    def get
      connection.get do |req|
        req.params = params
        req.params['appid'] = api_key
      end
    end

    private

    attr_reader :api_key

    def url
      raise NotImplementedError
    end

    def params
      raise NotImplementedError
    end

    def connection
      @connection ||= ::Faraday.new(
        url: url,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def log_error(class_name:, error_message:, error_code:)
      log = {
        class_name: class_name,
        error_message: error_message,
        error_code: error_code
      }.to_json
      Rails.logger.error(log)
    end
  end
end
