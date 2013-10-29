class SetupController < ApplicationController

  before_action :authenticate_by_session, only: :show
  before_action :authenticate_by_token,   only: :lighthouse

  def lighthouse
    @lighthouse_user = @user.lighthouse_users.where(
      token: params[:token]
    ).first_or_create  
    
    render :nothing => true
  end
  
  def show
  end
end
