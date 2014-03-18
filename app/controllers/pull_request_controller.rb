class PullRequestController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_branch
  before_action :existing_branch_only, :only => :create
  around_action :log_request

  def create
    PullRequest.new.update_branch(@branch)
    render nothing: true
  end
end
