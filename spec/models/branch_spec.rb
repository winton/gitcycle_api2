require 'spec_helper'

describe Branch do

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:params) do
    json_schema_params(:branch, :get)[0]
  end

  describe ".find_from_params" do

    before :each do
      Github.any_instance.stub(:user).
        and_return(name: "Github Name")
      
      Github.any_instance.stub(:repo).
        and_return(parent: {
          owner: {
            login: "owner_login",
            name:  "Owner Name"
          }
        })

      Github.any_instance.stub(:reference).
        and_return(ref: true)
    end

    def branch_expectations(branch, options={})
      options = {
        name_and_title: true,
        source_branch:  false
      }.merge(options)

      if options[:name_and_title]
        branch.name.should  == "hello-world"
        branch.title.should == "Hello, world!"
      end
      
      if options[:source_branch]
        branch.source_branch.name.should            == "master"
        branch.source_branch.repo.name.should       == "repo:name"
        branch.source_branch.repo.user.login.should == "owner_login"
        branch.source_branch.repo.user.name.should  == "Owner Name"
      end

      branch.repo.name.should       == "repo:name"
      branch.repo.user.login.should == "repo:user:login"
      branch.repo.user.name.should  == "Github Name"
      
      branch.user.login.should == "user:login"
      branch.user.name.should  == "user:name"
    end

    context "with minimum parameters" do
      it "initializes records" do
        branch = Branch.find_from_params(params, user)
        branch_expectations(branch, name_and_title: false)
      end
    end

    context "with source branch name" do
      it "initializes records" do
        params[:source_branch] = { name: "master" }
        branch = Branch.find_from_params(params, user)
        branch_expectations(branch,
          name_and_title: false,
          source_branch:  true
        )
      end
    end

    context "with title" do
      it "initializes records" do
        params[:title] = "Hello, world!"
        branch = Branch.find_from_params(params, user)
        branch_expectations(branch)
      end
    end

    context "with github url" do

      let(:github_url) { generate_github_url }

      it "initializes records" do
        Github.any_instance.stub(:issue).
          and_return(title: "Hello, world!")

        params[:github_url] = github_url
        branch = Branch.find_from_params(params, user)
        branch_expectations(branch)
        branch.github_issue_id.should == 123
      end
    end

    context "with lighthouse url" do

      let(:lighthouse_url) { generate_lighthouse_url }

      it "initializes records" do
        Lighthouse.any_instance.should_receive(:ticket).with(0, 0).
          and_return(title: "Hello, world!", body: "Ticket body")

        params[:lighthouse_url] = lighthouse_url
        branch = Branch.find_from_params(params, user)

        branch_expectations(branch)
        branch.lighthouse_namespace.should  == "namespace"
        branch.lighthouse_project_id.should == 0
        branch.lighthouse_ticket_id.should  == 0
      end
    end
  end
end
