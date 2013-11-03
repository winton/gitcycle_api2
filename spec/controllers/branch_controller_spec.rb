require 'spec_helper'

describe BranchController do
  before(:each) do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)

    Github.any_instance.stub(:repo).and_return(:parent => {
      :owner => {
        :login => "repo:owner:login",
        :name  => "repo:owner:name"
      }
    })

    Github.any_instance.stub(:user).and_return(
      :name => "repo:user:name"
    )

    Lighthouse.any_instance.stub(:ticket).and_return(
      :name  => "name",
      :title => "title"
    )
  end  

  let(:user) do
    FactoryGirl.create(:user)
  end

  context "with a lighthouse ticket" do
    
    let(:lighthouse_url) do
      "https://namespace.lighthouseapp.com/projects/0000/tickets/0000-ticket"
    end

    let(:branch) do
      FactoryGirl.create(:branch,
        lighthouse_url: lighthouse_url,
        user_id:        user.id
      )
    end

    context "when the user accepts the default branch" do

      let(:params) do
        json_schema_params(:branch, :post,
          request:  {
            lighthouse_url: lighthouse_url
          },
          response: {
            github_url:     nil,
            lighthouse_url: lighthouse_url
          }
        )
      end

      let(:req_params) { params[0] }
      let(:res_params) { params[1] }

      context "when branch already exists" do
        before(:each) do
          branch
          post(:create, req_params.merge(:format => :json))
        end

        it "should assign branch class instance variable" do
          expect(assigns(:branch)).to eq(branch)
        end

        it "should return correct response" do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body).to eql(res_params)
        end
      end

      context "when branch does not exist" do

        before(:each) do
          post(:create, req_params.deep_merge(:format => :json))
        end

        it "should return correct response" do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body).to eql(res_params)
        end
      end
    end
  end

  context "with a title" do
    let(:params) do
      json_schema_params(:branch, :post,
        request:  {
          title: "title"
        },
        response: {
          github_url:     nil,
          lighthouse_url: nil,
          name:           "title"
        }
      )
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    before(:each) do
      post(:create, req_params.deep_merge(:format => :json))
    end

    it "should return correct response" do
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to eql(res_params)
    end
  end
end
