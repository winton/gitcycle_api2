require 'spec_helper'

describe IssuesController do

  let(:user) do
    FactoryGirl.create(:user)
  end

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
  end

  describe :show do

    let(:branch) do
      FactoryGirl.create(:branch,
        github_issue_id: 123,
        user_id:         user.id
      )
    end

    let(:params) do
      json_schema_params(:issues, :get,
        request:  { issues: "123" },
        response: [
          {
            github_issue_id: 123,
            github_url:      "https://github.com/repo:owner:login/repo:name/pull/123",
            lighthouse_url:  nil
          }
        ]
      )
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    before(:each) do
      Github.any_instance.stub(:issue).and_return(title: "title")
    end

    it "returns correct response" do
      branch
      get(:show, req_params.merge(format: :json))
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to eql(res_params)
    end
  end
end
