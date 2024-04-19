module Errors
  class BadRequestError < StandardError
    attr_reader :error_code

    def initialize(message = 'Bad Request', error_code = 400)
      super(message)
      @error_code = error_code
    end
  end
end
