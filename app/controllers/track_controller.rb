class TrackController < ApplicationController

  before_action :authenticate_by_token

  def update
    track = Track.new(params, @user)
    render json: track.to_rpc
  end
end
