module Errors
  class UnauthorizedError < StandardError
    attr_reader :error_code

    def initialize(message = 'Unauthorized', error_code = 401)
      super(message)
      @error_code = error_code
    end
  end
end
