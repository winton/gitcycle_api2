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
    if params[:name]
      @branch = Branch.where(
        name:    params[:name],
        user_id: @user.id
      ).first_or_initialize
    elsif params[:source]
      @branch = Branch.where(
        source:  params[:source],
        user_id: @user.id
      ).first_or_initialize
    end

    render(nothing: true, status: :forbidden)  unless @branch
  end
end
