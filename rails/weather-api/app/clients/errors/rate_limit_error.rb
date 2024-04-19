module Errors
  class RateLimitError < StandardError
    attr_reader :error_code

    def initialize(message = 'Rate Limit Exceeded', error_code = 429)
      super(message)
      @error_code = error_code
    end
  end
end
