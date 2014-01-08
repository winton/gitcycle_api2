class LogsController < ApplicationController

  before_action :authenticate_by_session, only: [ :index, :show ]
  before_action :authenticate_by_token,   only: :create

  def index
    @logs = Log.all
  end

  def create
    Log.create_from_params(params, @user)
    render :nothing => true
  end

  def show
  end
end
