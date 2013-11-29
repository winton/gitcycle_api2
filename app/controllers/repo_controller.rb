class RepoController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_repo

  def create
    @repo.save
  end
end
