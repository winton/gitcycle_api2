require 'spec_helper'

describe SetupController do
  describe :lighthouse do
    let(:user) do
      FactoryGirl.create(:user)
    end

    before(:each) do
      Lighthouse.any_instance.stub(:memberships).and_return([
        { account: "http://namespace.lighthouseapp.com" },
        { account: "http://namespace2.lighthouseapp.com" }
      ])

      Lighthouse.any_instance.stub(:user).and_return(id: 1010)

      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)

      post(:lighthouse, :format => :json, :token => '0'*40)
    end

    it "creates LighthouseUser records" do
      expect(user.lighthouse_users.length).to eq(2)
      expect(user.lighthouse_users.collect(&:namespace)).to include('namespace', 'namespace2')
      expect(user.lighthouse_users.collect(&:lighthouse_id)).to eq([ 1010, 1010 ])
      expect(user.lighthouse_users.collect(&:user_id)).not_to include(nil)
    end
  end
end
