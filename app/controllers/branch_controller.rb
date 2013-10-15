class BranchController < ApplicationController

  before_action :find_branch, only: [ :create, :show ]

  def create
    render :show
  end

  def new
  end

  def show
  end

  private

  def find_branch
    if params[:name]
      @branch = Branch.where(name: params[:name]).first
    elsif params[:source]
      @branch = Branch.where(source: params[:source]).first
    end

    render(status: :forbidden)  unless @branch
  end
end
