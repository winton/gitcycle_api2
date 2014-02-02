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
        request: {
          branch: branch.name
        },
        response: {
          github_issue_id: 0,
          github_url:      generate_github_url(0),
          lighthouse_url:  :_DEL
        },
        required: :source_branch
      )
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    context "when branch exists" do

      it "returns correct response" do
        Github.any_instance.should_receive(:pull_request).and_return(
          issue_url: generate_github_url(0)
        )
        post(:create, req_params)
        body = parse_body(response.body)
        expect(body).to eql(res_params)
      end
    end

    context "when branch does not exist" do

      it "returns correct response" do
        Github.any_instance.should_receive(:repo).with().and_return({})
        Github.any_instance.stub(:reference).and_return({})
        Github.any_instance.stub(:user).and_return({})

        post(:create, req_params.merge(name: "doesnt-exist"))
        response.status.should eql(403)
      end
    end
  end
end
