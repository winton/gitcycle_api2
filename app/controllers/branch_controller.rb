class BranchController < ApplicationController

  before_action :authenticate_by_token
  before_action :find_branch
  before_action :existing_branch_only, :only => :update

  def create
    @branch.create_from_params(params)
    render :show
  end

  def show
  end

  def update
    @branch.update_attributes(
      name:   params[:name],
      source: params[:source]
    )
    render :show
  end

  private

  def find_branch
    @branch = Branch.find_from_params(params, @user)
    render(nothing: true, status: :forbidden)  unless @branch
  end

  def existing_branch_only
    render(nothing: true, status: :forbidden)  if @branch.new_record?
  end
end
