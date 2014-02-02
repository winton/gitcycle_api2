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
          login: "source_branch:user:login",
          name:  "source_branch:user:name"
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
      
      let(:lighthouse_url) { generate_lighthouse_url }

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
              github_issue_id: :_DEL,
              github_url:      :_DEL,
              lighthouse_url:  lighthouse_url
            },
            required: :source_branch
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
            body = parse_body(response.body)
            expect(body).to eql(res_params)
          end
        end

        context "when branch does not exist" do

          let(:res_params) do
            JsonSchemaSpec::Util.deep_merge(params[1],
              source_branch: { title: :_DEL }
            )
          end

          before(:each) do
            post(:create, req_params.merge(format: :json))
          end

          it "returns correct response" do
            body = parse_body(response.body)
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
            github_issue_id: :_DEL,
            github_url:      :_DEL,
            lighthouse_url:  :_DEL,
            source_branch:   { title: :_DEL }
          },
          required: :source_branch
        )
      end

      let(:req_params) { params[0] }
      let(:res_params) { params[1] }

      before(:each) do
        post(:create, req_params.merge(format: :json))
      end

      it "returns correct response" do
        body = parse_body(response.body)
        expect(body).to eql(res_params)
      end
    end

    context "with a github issue" do

      let(:github_url) { generate_github_url(0) }

      let(:params) do
        json_schema_params(:branch, :post,
          request:  {
            github_url: github_url
          },
          response: {
            github_issue_id: 0,
            github_url:      github_url,
            lighthouse_url:  :_DEL,
            source_branch:   { title: :_DEL }
          },
          required: :source_branch
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
        body = parse_body(response.body)
        expect(body).to eql(res_params)
      end
    end
  end

  describe :update do
    let(:params) do
      json_schema_params(:branch, :put,
        response: {
          github_issue_id: :_DEL,
          github_url:      :_DEL,
          lighthouse_url:  :_DEL
        },
        required: :source_branch
      )
    end

    let(:req_params) { params[0] }
    let(:res_params) { params[1] }

    let(:branch) do
      FactoryGirl.create(:branch, user_id: user.id)
    end

    it "returns correct response" do
      branch
      put(:update, req_params.merge(format: :json))
      body = parse_body(response.body)

      expect(body).to eql(res_params)
    end
  end
end
