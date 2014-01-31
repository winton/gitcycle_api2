class SetupController < ApplicationController

  before_action :authenticate_by_session, only: :show
  before_action :authenticate_by_token,   only: :lighthouse
  around_action :log_request,             only: :lighthouse

  def lighthouse
    LighthouseUser.find_from_params(params, @user)
    render nothing: true
  end
  
  def show
  end
end
