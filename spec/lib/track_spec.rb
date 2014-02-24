require 'spec_helper'

describe Track do

  let(:user) { FactoryGirl.create(:user) }

  describe "#build_branch" do

    it "finds the branch" do
      track = Track.new(branch: "branch")
      expect(track.build_branch).to be_a(Branch)
    end

    it "sets the user" do
      track  = Track.new(branch: "branch")
      branch = track.build_branch(user)
      expect(branch.user).to be(user)
    end

    it "resets the branch" do
      Track.new(branch: "branch").find_branch.save
      track  = Track.new(branch: "branch", reset: true)
      branch = track.build_branch
      expect(branch.id).to be_nil
    end

    it "sets the source branch" do
      track  = Track.new(branch: "branch", source: "source")
      branch = track.build_branch
      expect(branch.source_branch).to be_a(Branch)
      expect(branch.source_branch.name).to eq("source")
    end
  end

  describe "#find_branch" do
    it "uses #to_conditions to find Branch" do
      branch = double(:branch)
      track  = Track.new({})

      Branch.should_receive(:where).
        with(track.to_conditions).ordered.and_return(branch)
      branch.should_receive(:first_or_initialize).with().ordered

      track.find_branch
    end
  end

  context "with branch parameter" do

    let :params do
      { branch: "branch" }
    end

    subject { Track.new(params) }

    describe "#to_conditions" do

      it "adds name to conditions" do
        expect(subject.to_conditions).to eq(name: "branch")
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

    subject { Track.new(params) }

    describe "#to_conditions" do

      it "adds name to conditions" do
        expect(subject.to_conditions).to eq(name: "branch")
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

    subject { Track.new(params) }

    describe "#to_conditions" do

      it "adds name to conditions" do
        expect(subject.to_conditions).to eq(github_issue_id: "123")
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

    subject { Track.new(params) }

    describe "#to_conditions" do

      it "adds name to conditions" do
        expect(subject.to_conditions).to eq(
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

    subject { Track.new(params) }

    describe "#to_conditions" do

      it "adds name to conditions" do
        expect(subject.to_conditions).to eq(title: title)
      end
    end

    describe "#to_options" do

      it "adds title option" do
        expect(subject.to_options).to eq(response)
      end
    end
  end

  describe "#update_branch" do
    it "initializes UpdateBranch" do
      branch        = double(:branch)
      update_branch = double(:update_branch)
      user          = double(:user)
      track         = Track.new({})

      track.should_receive(:build_branch).
        with(user).ordered.and_return(branch)

      UpdateBranch.should_receive(:new).
        with(branch).ordered.and_return(update_branch)
      
      update_branch.should_receive(:update).ordered

      track.update_branch(user)
    end
  end
end