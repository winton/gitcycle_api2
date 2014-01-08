require 'spec_helper'

describe LogsController do
  describe :create do

    let(:now) do
      Time.now.utc
    end

    let(:user) do
      FactoryGirl.create(:user)
    end

    let(:params) do
      json_schema_params(:logs, :post, request: { events: [ ran_at: now.to_s ] })
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    before(:each) do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
      user.logs.delete_all
      post(:create, req_params.merge(:format => :json))
      user.logs.reload
    end

    it "creates Log record" do
      expect(user.logs.length).to eq(1)
      expect(user.logs.first.event).to       eq("events:event")
      expect(user.logs.first.body).to        eq("events:body")
      expect(user.logs.first.session_id).to  eq("events:session_id")
      expect(user.logs.first.user_id).to     eq(user.id)
      expect(user.logs.first.ran_at.to_s).to eq(now.to_s)
    end
  end
end
