class SessionController < ApplicationController

  def create
    auth = request.env['omniauth.auth']

    user = User.where(
      github:   auth.credentials.token,
      login:    auth.info.nickname
    ).first_or_initialize

    user.update_attributes(
      gravatar: auth.extra.raw_info.gravatar_id,
      name:     auth.info.name
    )
    
    session[:user] = user
    redirect_to '/'
  end

  def destroy
    session.delete(:user)
    redirect_to '/'
  end

  def show
    render :json => session[:user]
  end
end
