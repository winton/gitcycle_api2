class BranchController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_branch
  around_action :log_request

  def create
    @branch.create_from_params(params)
    render :show
  end

  def show
  end

  def update
    @branch.update_attributes(name: params[:name])
    render :show
  end
end
