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

    subject do
      put(:update, { repo: "repo", query: "query" }.merge(format: :json))
      JSON.parse(response.body, symbolize_names: true)
    end

    specify { expect(subject[:branch]).to   be_a(Hash) }
    specify { expect(subject[:commands]).to be_a(Array) }
  end
end
