require 'spec_helper'

describe BranchController do
  context "with a lighthouse ticket" do
    
    let(:lighthouse_url) do
      "https://test.lighthouseapp.com/projects/0000/tickets/0000-ticket"
    end

    let(:branch) do
      FactoryGirl.create(:branch,
        lighthouse_url: lighthouse_url,
        user_id:        user.id
      )
    end

    let(:user) do
      FactoryGirl.create(:user)
    end

    before(:each) do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
    end

    context "when the user accepts the default branch" do

      let(:params) do
        json_schema_params(:branch, :post,
          request:  { lighthouse_url: lighthouse_url },
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

      # TODO: figure out a way to assign owner_id
      # context "when branch does not exist" do
      #   before(:each) do
      #     post(:create, req_params.merge(:format => :json))
      #   end

      #   it "should return correct response" do
      #     body = JSON.parse(response.body, symbolize_names: true)
      #     expect(body).to eql(res_params)
      #   end
      # end
    end
  end
end
