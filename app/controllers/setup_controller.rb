class SetupController < ApplicationController

  before_action :authenticate_by_session, only: :show
  before_action :authenticate_by_token,   only: :lighthouse
  around_action :log_request,             only: :lighthouse

  def lighthouse
    @user.lighthouse_users.where(
      namespace: nil,
      token:     params[:token]
    ).first_or_create

    render nothing: true
  end
  
  def show
  end
end
