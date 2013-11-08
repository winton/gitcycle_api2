require 'spec_helper'

describe SetupController do
  describe :lighthouse do
    let(:user) do
      FactoryGirl.create(:user)
    end

    before(:each) do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
      user.lighthouse_users.delete_all
      post(:lighthouse, :format => :json, :token => 'token')
      user.lighthouse_users.reload
    end

    it "creates LighthouseUser record" do
      expect(user.lighthouse_users.length).to eq(1)
      expect(user.lighthouse_users.first.namespace).to be_nil
      expect(user.lighthouse_users.first.token).to eq("token")
      expect(user.lighthouse_users.first.lighthouse_id).to be_nil
      expect(user.lighthouse_users.first.user_id).to eq(user.id)
    end
  end
end
