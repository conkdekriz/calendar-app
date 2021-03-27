# frozen_string_literal: true

module Hbt
  # ErrorResponse manages the outcome of an unsuccessful request to the server.
  # Serves the list of errors given by the API.
  class ErrorResponse < Response
    def initialize(hash, model_name: nil) # rubocop:disable Lint/UnusedMethodArgument
      super()
      @hash = hash
    end

    # Returns the list of errors that came back from the request
    # @return[Hash] The content of the error message
    def errors
      @hash[:body][:errors]
    end

    # Tells that the response is an error
    # @return [Boolean] true
    def error?
      true
    end
  end
end
