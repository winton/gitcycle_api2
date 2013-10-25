require 'spec_helper'

describe BranchController do
  context "with a lighthouse ticket" do
    
    let(:lighthouse_url) do
      "https://test.lighthouseapp.com/projects/0000/tickets/0000-ticket"
    end

    let(:create_branch) do
      FactoryGirl.create(:branch)
    end

    context "when the user accepts the default branch" do

      let(:params) do
        json_schema_params(:branch, :post,
          request: { lighthouse_url: lighthouse_url },
          respose: { lighthouse_url: lighthouse_url }
        )
      end

      it "works" do
        request_params, response_params = params
        create_branch
        post(:create, request_params)
        puts response.body.inspect
      end
    end
  end
end
