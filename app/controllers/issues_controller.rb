class IssuesController < ApplicationController

  before_action :authenticate_by_token
  before_action :parse_issues
  around_action :log_request

  def show    
  end

  def update
    @branches.each do |branch|
      branch.update_attributes :state => params[:state]
    end
    
    render :show
  end

  private

  def parse_issues
    @issues   = params[:issues].split(',').map(&:to_i)
    @branches = Branch.where(:github_issue_id => @issues)

    render(nothing: true, status: :forbidden)  if @branches.empty?
  end
end
