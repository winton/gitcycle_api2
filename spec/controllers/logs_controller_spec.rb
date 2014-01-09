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
      json_schema_params(:logs, :post, request: { events: [ ran_at: now.to_i ] })
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

    it "creates Log records" do
      expect(user.logs.length).to eq(1)
      expect(user.logs.first.log_entries.length).to eq(1)

      log       = user.logs.first
      log_entry = log.log_entries.first

      expect(log_entry.event).to           eq("events:event")
      expect(log_entry.body).to            eq("events:body")
      expect(log_entry.backtrace).to       eq("events:backtrace")
      expect(log_entry.ran_at.utc.to_s).to eq(now.to_s)

      expect(log.exit_code).to            eq("events:body")
      expect(log.user_id).to              eq(user.id)
      expect(log.started_at.utc.to_s).to  eq(now.to_s)
      expect(log.finished_at.utc.to_s).to eq(now.to_s)
    end
  end
end
