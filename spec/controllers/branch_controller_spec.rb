require 'spec_helper'

describe BranchController do

  let(:user) do
    FactoryGirl.create(:user)
  end

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
  end

  describe :create do
    before :each do
      Github.any_instance.stub(:repo).and_return(parent: {
        owner: {
          login: "repo:owner:login",
          name:  "repo:owner:name"
        }
      })

      Github.any_instance.stub(:user).and_return(
        name: "repo:user:name"
      )

      Lighthouse.any_instance.stub(:ticket).and_return(
        name:  "name",
        title: "title"
      )
    end

    context "with a lighthouse ticket" do
      
      let(:lighthouse_url) do
        "https://namespace.lighthouseapp.com/projects/0/tickets/0"
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
            post(:create, req_params.merge(format: :json))
          end

          it "assigns branch class instance variable" do
            expect(assigns(:branch)).to eq(branch)
          end

          it "returns correct response" do
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body).to eql(res_params)
          end
        end

        context "when branch does not exist" do

          let(:res_params) { params[1].merge(name: "title") }

          before(:each) do
            post(:create, req_params.merge(format: :json))
          end

          it "returns correct response" do
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
        post(:create, req_params.merge(format: :json))
      end

      it "returns correct response" do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body).to eql(res_params)
      end
    end

    context "with a github issue" do

      let(:github_url) { "https://github.com/repo:owner:login/repo:name/pull/0" }

      let(:params) do
        json_schema_params(:branch, :post,
          request:  {
            github_url: github_url
          },
          response: {
            github_url:     github_url,
            lighthouse_url: nil,
            name:           "title"
          }
        )
      end

      let(:req_params) { params[0] }
      let(:res_params) { params[1] }

      before(:each) do
        Github.any_instance.stub(:issue).and_return(
          name:  "name",
          title: "title"
        )
      end

      it "returns correct response" do
        post(:create, req_params.merge(format: :json))
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body).to eql(res_params)
      end
    end
  end

  describe :update do
    let(:params) do
      json_schema_params(:branch, :put, response: {
        github_url:     nil,
        lighthouse_url: nil
      })
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    let(:branch) do
      FactoryGirl.create(:branch, user_id: user.id)
    end

    it "returns correct response" do
      branch
      put(:update, req_params.merge(format: :json))
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to eql(res_params)
    end
  end
end
