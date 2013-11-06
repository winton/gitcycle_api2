class SetupController < ApplicationController

  before_action :authenticate_by_session, only: :show
  before_action :authenticate_by_token,   only: :lighthouse

  def lighthouse
    @user.build_lighthouse_users_from_token(params[:token])
    render :nothing => true
  end
  
  def show
  end
end
