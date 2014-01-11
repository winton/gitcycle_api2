class RepoController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_repo
  around_action :log_request

  def create
    @repo.save
  end
end
