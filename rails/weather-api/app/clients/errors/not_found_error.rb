module Errors
  class NotFoundError < StandardError
    attr_reader :error_code

    def initialize(message = 'Not Found', error_code = 404)
      super(message)
      @error_code = error_code
    end
  end
end
