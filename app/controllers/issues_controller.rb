# frozen_string_literal: true

class IssuesController < ApplicationController # rubocop:todo Style/Documentation

  before_action :set_issues, only: %i[index show]

  def index; end

  def show; end

  def all; end

  def set_issues
    uc = UseCases::ShowIssues.new(user_token: user_token)

    return invalid_user_show(uc.errors) unless uc.valid?
    uc.execute
    
    return invalid_user_show(uc.errors) unless uc.success?
    @issues = uc
  end

  def invalid_user_show(err)
    @error = err
    redirect_to all_issues_path
  end

end
