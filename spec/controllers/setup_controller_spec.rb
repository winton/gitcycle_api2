require 'spec_helper'

describe SetupController do
  describe :lighthouse do
    let(:user) do
      FactoryGirl.create(:user)
    end

    before(:each) do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
      post(:lighthouse, :format => :json, :token => '0'*40)
    end

    it "creates a LighthouseUser record" do
      expect(assigns(:lighthouse_user).id).to      be_a_kind_of(Fixnum)
      expect(assigns(:lighthouse_user).token).to   eq('0'*40)
      expect(assigns(:lighthouse_user).user_id).to eq(user.id)
    end
  end
end
