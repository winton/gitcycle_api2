class TrackController < ApplicationController

  before_action :authenticate_by_token

  def update
    render json: Rpc.new(params, @user).track
  end
end
