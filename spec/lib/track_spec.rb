require 'spec_helper'

describe Track do

  let(:branch) { double(:branch) }
  let(:repo)   { double(:repo) }
  let(:source) { double(:source) }
  let(:user)   { double(:user) }

  describe "#branch_conditions, #to_options" do
    
    context "with branch parameter" do

      let :params do
        { branch: "branch" }
      end

      subject { Track.new(params, user) }

      describe "#branch_conditions" do

        it "adds name to conditions" do
          expect(subject.branch_conditions).to eq(name: "branch")
        end
      end

      describe "#to_options" do

        it "adds branch option" do
          expect(subject.to_options).to eq(params)
        end
      end
    end

    context "with \"branch\" query parameter" do

      let :params do
        { query: "branch" }
      end

      let :response do
        { branch: "branch", query: "branch" }
      end

      subject { Track.new(params, user) }

      describe "#branch_conditions" do

        it "adds name to conditions" do
          expect(subject.branch_conditions).to eq(name: "branch")
        end
      end

      describe "#to_options" do

        it "adds branch option" do
          expect(subject.to_options).to eq(response)
        end
      end
    end

    context "with github URL query parameter" do

      let(:github_url) { generate_github_url }

      let :params do
        { query: github_url }
      end

      let :response do
        { github_url: github_url,
          query:      github_url }
      end

      subject { Track.new(params, user) }

      describe "#branch_conditions" do

        it "adds name to conditions" do
          expect(subject.branch_conditions).to eq(github_issue_id: "123")
        end
      end

      describe "#to_options" do

        it "adds github_url option" do
          expect(subject.to_options).to eq(response)
        end
      end
    end

    context "with lighthouse URL query parameter" do

      let :params do
        { query: generate_lighthouse_url }
      end

      let :response do
        { lighthouse_url: generate_lighthouse_url,
          query: generate_lighthouse_url }
      end

      subject { Track.new(params, user) }

      describe "#branch_conditions" do

        it "adds name to conditions" do
          expect(subject.branch_conditions).to eq(
            lighthouse_namespace:  "namespace",
            lighthouse_project_id: "0",
            lighthouse_ticket_id:  "0"
          )
        end
      end

      describe "#to_options" do

        it "adds lighthouse_url option" do
          expect(subject.to_options).to eq(response)
        end
      end
    end

    context "with title query parameter" do

      let(:title) { "Hello, world!" }

      let :params do
        { query: title }
      end

      let :response do
        { title: title, query: title }
      end

      subject { Track.new(params, user) }

      describe "#branch_conditions" do

        it "adds name to conditions" do
          expect(subject.branch_conditions).to eq(title: title)
        end
      end

      describe "#to_options" do

        it "adds title option" do
          expect(subject.to_options).to eq(response)
        end
      end
    end
  end

  describe "#build_branch" do

    def new_track(options)
      track = Track.new(options, user)
      track.should_receive(:find_branch).ordered.and_return(branch)
      track
    end

    it "finds the branch" do
      track = new_track(branch: "branch")
      branch.should_receive(:user=).with(user).ordered
      expect(track.build_branch).to eq(branch)
    end

    it "resets the branch" do
      track      = new_track(branch: "branch", reset: true)
      new_branch = double(:new_branch)
      track.should_receive(:reset_branch).ordered.with(branch).and_return(new_branch)
      new_branch.should_receive(:user=).with(user)
      expect(track.build_branch).to eq(new_branch)
    end

    it "sets the user" do
      track = new_track(branch: "branch")
      branch.should_receive(:user=).with(user)
      track.build_branch
    end

    it "sets the repo" do
      track = new_track(branch: "branch", repo: "user/repo")
      branch.should_receive(:user=).ordered.with(user)
      track.should_receive(:find_repo).ordered.and_return(repo)
      branch.should_receive(:repo=).ordered.with(repo)
      track.build_branch
    end

    it "sets the source branch" do
      track = new_track(branch: "branch", source: "source")
      branch.should_receive(:user=).with(user).ordered
      track.should_receive(:pick_source).ordered.with(branch).and_return(source)
      branch.should_receive(:source_branch=).ordered.with(source)
      track.build_branch
    end
  end

  describe "#find_branch" do

    it "uses #branch_conditions to find Branch" do
      track = Track.new({}, user)
      conditions = double(:conditions)

      track.should_receive(:branch_conditions).ordered.and_return(conditions)
      Branch.should_receive(:where).with(conditions).ordered.and_return(branch)
      branch.should_receive(:first_or_initialize).with().ordered

      track.find_branch
    end
  end

  describe "#find_repo" do
    
    it "uses #branch_conditions to find Branch" do
      track = Track.new({}, user)
      conditions = double(:conditions)

      track.should_receive(:repo_conditions).ordered.and_return(conditions)
      Repo.should_receive(:where).with(conditions).ordered.and_return(repo)
      repo.should_receive(:first_or_initialize).with().ordered

      track.find_repo
    end
  end

  describe "#owner_branch_exists?" do

    it "checks if owner branch is present" do
      owner = double(:owner)

      branch.should_receive(:repo).ordered.and_return(repo)
      repo.should_receive(:owner).ordered.and_return(owner)
      
      track = Track.new({}, user)
      track.should_receive(:github_ref_exists?).ordered.with(user, branch, owner).and_return(true)
      expect(track.owner_branch_exists?(branch)).to eq(owner)
    end
  end

  describe "#parse_query" do

    it "returns branch" do
      track = Track.new({}, user)
      branch, title, url = track.parse_query("branch")
      expect(branch).to eq("branch")
      expect(title).to  be_nil
      expect(url).to    be_nil
    end

    it "returns title" do
      track = Track.new({}, user)
      branch, title, url = track.parse_query("hello world")
      expect(branch).to be_nil
      expect(title).to  eq("hello world")
      expect(url).to    be_nil
    end

    it "returns url" do
      track = Track.new({}, user)
      branch, title, url = track.parse_query("http://x")
      expect(branch).to be_nil
      expect(title).to  be_nil
      expect(url).to    eq("http://x")
    end
  end

  describe "#pick_source" do

    let(:new_branch) { double(:new_branch) }
    let(:new_track)  { double(:new_track) }

    context "with source option including a repo" do

      it "calls Track#build_branch with proper parameters" do
        track = Track.new({ source: "repo/source" }, user)

        Track.should_receive(:new).with(branch: "source", repo: "repo").
          ordered.and_return(new_track)
        new_track.should_receive(:build_branch).ordered.and_return(new_branch)
        
        expect(track.pick_source(branch)).to eq(new_branch)
      end
    end

    context "with source option not including a repo" do

      let(:track) { Track.new({ source: "source" }, user) }

      context "owner branch exists" do
      
        it "calls Track#build_branch with proper parameters" do
          owner = double(:owner)

          track.should_receive(:owner_branch_exists?).with(branch).
            ordered.and_return(owner)
          owner.should_receive(:login).ordered.and_return("owner")
          branch.should_receive(:repo).ordered.and_return(repo)
          repo.should_receive(:name).ordered.and_return("repo")
          Track.should_receive(:new).with(branch: "source", repo: "owner/repo").
            ordered.and_return(new_track)
          new_track.should_receive(:build_branch).ordered.and_return(new_branch)
          
          expect(track.pick_source(branch)).to eq(new_branch)
        end
      end

      context "owner branch doesn't exists" do
      
        it "calls Track#build_branch with proper parameters" do
          owner = double(:owner)

          track.should_receive(:owner_branch_exists?).with(branch).
            ordered.and_return(false)
          branch.should_receive(:repo).ordered.and_return(repo)
          repo.should_receive(:name).ordered.and_return("repo")
          Track.should_receive(:new).with(branch: "source", repo: "repo").
            ordered.and_return(new_track)
          new_track.should_receive(:build_branch).ordered.and_return(new_branch)
          
          expect(track.pick_source(branch)).to eq(new_branch)
        end
      end
    end
  end

  describe "#repo_conditions" do

    it "accepts a repo in simple format" do
      track = Track.new({ repo: "repo" }, user)
      user.should_receive(:id).ordered.and_return(1)
      expect(track.repo_conditions).to eq(name: "repo", user_id: 1)
    end

    it "accepts a repo in user/repo format" do
      track = Track.new({ repo: "user/repo" }, user)
      User.should_receive(:where).ordered.with(login: "user").and_return(user)
      user.should_receive(:first_or_create).ordered.and_return(user)
      user.should_receive(:id).ordered.and_return(1)
      expect(track.repo_conditions).to eq(name: "repo", user_id: 1)
    end
  end

  describe "#update_branch" do

    it "initializes UpdateBranch" do
      update_branch = double(:update_branch)
      track         = Track.new({}, user)

      track.should_receive(:build_branch).
        with().ordered.and_return(branch)

      UpdateBranch.should_receive(:new).
        with(branch).ordered.and_return(update_branch)
      
      update_branch.should_receive(:update).ordered.and_return(branch)
      branch.should_receive(:save).ordered

      track.update_branch
    end
  end

  describe "#to_rpc" do

    it "returns RPC hash" do
      track = Track.new({}, user)
      track.should_receive(:update_branch).and_return(branch)
      expect(track.to_rpc).to eq(
        branch: branch, commands: [ :checkout_from_remote ]
      )
    end
  end

  describe "#ticket_provider_option" do

    context "with lighthouse URL" do

      let(:lighthouse_url) { "http://lighthouseapp.com/test" }
    
      it "returns proper hash" do
        track  = Track.new({})
        result = track.ticket_provider_option(lighthouse_url)
        expect(result).to eq(lighthouse_url: lighthouse_url)
      end
    end

    context "with github URL" do

      let(:github_url) { "http://github.com/test" }
    
      it "returns proper hash" do
        track  = Track.new({})
        result = track.ticket_provider_option(github_url)
        expect(result).to eq(github_url: github_url)
      end
    end
  end
end