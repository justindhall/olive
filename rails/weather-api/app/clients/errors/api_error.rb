module Errors
  class ApiError < StandardError
    attr_reader :error_code

    def initialize(message = 'API Error', error_code)
      super(message)
      @error_code = error_code
    end
  end
end
