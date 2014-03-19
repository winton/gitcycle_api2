class TrackController < ApplicationController

  before_action :authenticate_by_token
  around_filter :log_request

  def update
    render json: Rpc.new(params, @user).track
  end
end
