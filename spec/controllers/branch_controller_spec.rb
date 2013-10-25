require 'spec_helper'

describe BranchController do
  context "with a lighthouse ticket" do
    
    let(:lighthouse_url) do
      "https://test.lighthouseapp.com/projects/0000/tickets/0000-ticket"
    end

    let(:branch) do
      FactoryGirl.create(:branch)
    end

    context "when the user accepts the default branch" do

      let(:params) do
        json_schema_params(:branch, :post,
          request: { lighthouse_url: lighthouse_url },
          respose: { lighthouse_url: lighthouse_url }
        )
      end

      before(:each) { branch }

      it "works" do
        request_params, response_params = params
        post(:create, request_params.merge(:format => :json))
        expect(assigns(:branch)).to eq(branch)
        puts response.body.inspect
      end
    end
  end
end