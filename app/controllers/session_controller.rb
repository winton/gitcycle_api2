class SessionController < ApplicationController

  def create
    auth = request.env['omniauth.auth']

    user = User.where(login: auth.info.nickname).first_or_initialize

    user.update_attributes(
      github:   auth.credentials.token,
      gravatar: auth.extra.raw_info.gravatar_id,
      name:     auth.info.name
    )
    
    session[:user] = user
    redirect_to '/setup'
  end

  def destroy
    session.delete(:user)
    redirect_to '/'
  end

  def show
    render :json => session[:user]
  end
end
