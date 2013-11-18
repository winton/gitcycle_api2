class PullRequestController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_branch
  before_action :existing_branch_only, :only => :create

  def create
    @branch.create_pull_request
    render "branch/show"
  end
end
