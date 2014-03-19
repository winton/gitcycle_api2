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

    let(:query)  { "query" }
    let(:repo)   { "repo" }
    let(:source) { "source" }

    before do
      Repo.any_instance.stub(:owner).and_return(user)
      Github.any_instance.stub(:reference).and_return(ref: true)
    end

    subject do
      put(:update, { repo: repo, query: query, source: source }.merge(format: :json))
      JSON.parse(response.body, symbolize_names: true)
    end

    specify { expect(subject[:commands]).to be_a(Array) }
  end
end
