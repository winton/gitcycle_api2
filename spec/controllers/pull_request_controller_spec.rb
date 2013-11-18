require 'spec_helper'

describe PullRequestController do

  let(:branch) do
    FactoryGirl.create(:branch, user_id: user.id)
  end

  let(:user) do
    FactoryGirl.create(:user)
  end

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
  end

  describe :create do

    let(:params) do
      json_schema_params(:pull_request, :post,
        response: {
          github_url:     "https://github.com/repo:owner:login/repo:name/pull/0",
          lighthouse_url: nil
        }
      )
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    it "returns correct response" do
      Github.any_instance.should_receive(:pull_request).and_return(
        issue_url: "https://github.com/repo:owner:login/repo:name/pull/0"
      )
      Github.any_instance.should_receive(:issue).and_return(
        title: "title"
      )
      post(:create, name: branch.name)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to eql(res_params)
    end
  end
end
