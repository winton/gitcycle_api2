class PullRequestController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_branch
  before_action :existing_branch_only, :only => :create
  around_action :log_request

  def create
    @branch.create_pull_request
    render "branch/show.json", locals: { branch: @branch }
  end
end
