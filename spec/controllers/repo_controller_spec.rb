require 'spec_helper'

describe RepoController do

  let(:user) do
    FactoryGirl.create(:user)
  end

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
  end

  describe :create do

    let(:params) do
      json_schema_params(:repo, :post)
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    it "returns correct response" do
      Github.any_instance.stub(:user).and_return(name: "user:name")
      Github.any_instance.stub(:repo).and_return(parent: {
        owner: {
          login: "owner:login",
          name:  "owner:name"
        }
      })

      post(:create, req_params.merge(format: :json))
      
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to eql(res_params)
    end
  end
end
