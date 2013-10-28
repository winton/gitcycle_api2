class BranchController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_branch

  def create
    @branch.create_from_params(params)
    render action: :show
  end

  def show
  end

  private

  def find_branch
    @branch = Branch.find_from_params(params, @user)
    render(nothing: true, status: :forbidden)  unless @branch
  end
end
