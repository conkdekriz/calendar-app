# frozen_string_literal: true

module UseCases
  class ShowIssues < UseCase # rubocop:todo Style/Documentation
    def initialize(user_token: nil)
      super()
      @user_token = user_token

    end

    def validate
      error('NO_USER_TOKEN') if @user_token.nil?
    end

    def internal_execute
      issues = Issues.show(user_token: @user_token)
      issues
    end

    def after_run(result)
      @result = result.body
    end
  end
end
