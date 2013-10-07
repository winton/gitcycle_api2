class ApplicationController < ActionController::Base

  protect_from_forgery

  def authenticate_by_token
    authenticate_or_request_with_http_token do |token, options|
      @user = User.where(gitcycle: token).first
    end
  end

  def authenticate_by_session
    redirect_to '/' unless session[:user]
  end
end
