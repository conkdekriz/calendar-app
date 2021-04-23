# frozen_string_literal: true

module UseCases
  # Base for implementing Use Cases.
  # This structure is derived from the Command GoF Pattern.
  # All use cases are initialized with the own specific parameters
  # and may return after beign invoked by the `execute` method.
  class UseCase
    attr_reader :errors, :result
    
    def error(str)
      @errors << str
    end

    def execute
      return false unless valid?

      prepare

      result = internal_execute

      after_run result 
    rescue StandardError => e
      Rails.logger.error "Failed to execute #{self.class}"
      Rails.logger.error e.message
      Rails.logger.debug e.backtrace
      raise e
    end

    def prepare; end

    def execute!
      raise ArgumentError unless valid?

      prepare

      internal_execute
    end

    def run_validations; end

    def valid?
      @errors = []
      run_validations
      @errors.empty?
    rescue StandardError => e
      Rails.logger.error "StandardError detected #{e.message}"
      Rails.logger.debug e.backtrace
      @errors << e.message
      true
    end

    def success?
      @errors.empty?
    end

    def show_error; end
  end
end