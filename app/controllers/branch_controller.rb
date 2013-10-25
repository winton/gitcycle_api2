class BranchController < ApplicationController

  before_action :find_branch, only: [ :create, :show ]

  def create
    render text: "hello"
  end

  def new
  end

  def show
    render text: "hello"
  end

  private

  def find_branch
    if params[:name]
      @branch = Branch.where(name: params[:name]).first
    elsif params[:source]
      @branch = Branch.where(source: params[:source]).first
    end

    render(nothing: true, status: :forbidden)  unless @branch
  end
end
