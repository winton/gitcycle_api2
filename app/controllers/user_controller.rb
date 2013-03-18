class UserController < ApplicationController

  before_filter :authenticate_by_token

  # curl http://localhost:3000/user.json -H 'Authorization: Token token="82410be9c75d6985"'
  def show
  end
end
