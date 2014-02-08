class TrackController < ApplicationController

  before_action :authenticate_by_token

  def update
    Track.new(params).update_branch(@user)
  end
end
