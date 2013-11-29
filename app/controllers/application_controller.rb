class ApplicationController < ActionController::Base

  protect_from_forgery

  private

  def authenticate_by_token
    authenticate_or_request_with_http_token do |token, options|
      @user = User.where(gitcycle: token).first
    end
  end

  def authenticate_by_session
    redirect_to '/' unless session[:user]
  end

  def existing_branch_only
    render(nothing: true, status: :forbidden)  if @branch.new_record?
  end

  def find_branch
    @branch = Branch.find_from_params(params, @user)
    render(nothing: true, status: :forbidden)  unless @branch
  end

  def find_repo
    @repo = Repo.find_from_params(params)
    render(nothing: true, status: :forbidden)  unless @repo
  end
end
