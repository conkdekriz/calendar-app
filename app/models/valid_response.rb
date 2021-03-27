# frozen_string_literal: true

module Hbt
  # Encapsulates a valid HBT API Response
  class ValidResponse < Response
    def initialize(hash, model_name: nil)
      super()
      @hash = hash
      @model_name = model_name
      @body = nil
    end

    # Returns an Object or an Array of Objects resulting from a correct request to the API
    def body
      return @body unless @body.nil?

      data = @hash[:body][:data]
      return @body = ModelBuilder.build(data, name: @model_name) unless data.is_a? Array

      @body = data.map do |datum|
        ModelBuilder.build(datum, name: @model_name)
      end
    end

    # @return [String] String respresentation of the cookies
    def cookies
      @hash[:cookies]
    end

    # @return [Boolean] true
    def valid?
      true
    end

    def to_s
      "Hbt Valid Response @body=#{body}"
    end
  end
end
