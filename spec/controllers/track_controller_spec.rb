require 'spec_helper'

describe TrackController do

  let(:user) do
    FactoryGirl.create(:user)
  end

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
  end

  describe "PUT #track" do
    it "renders rpc json" do
      put(:update, { repo: "repo", query: "query" }.merge(format: :json))
      body = JSON.parse(response.body, symbolize_names: true)
      puts body
      expect(body[:branch]).to   be_a(Hash)
      expect(body[:commands]).to be_a(Array)
    end
  end
end
