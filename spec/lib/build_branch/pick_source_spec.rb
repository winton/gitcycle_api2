require 'spec_helper'

describe BuildBranch::PickSource do

  let(:branch)      { double }
  let(:source)      { "" }
  let(:pick_source) { BuildBranch::PickSource.new(branch, source) }
  subject           { pick_source }

  describe "#build_branch" do
    
    subject { pick_source.build_branch }

    let(:build) { double }

    before { BuildBranch.any_instance.stub(:build).and_return(build) }

    it { should == build }
  end

  describe "#github" do
    
    subject { pick_source.github }

    let(:branch) { double(repo: nil, user: nil) }
    let(:github) { double }

    before do
      pick_source.branch = branch
      allow(Github).to receive(:new).and_return(github)
    end

    it { should == github }
  end

  describe "#github_ref_exists?" do
    
    let(:github) { double }
    let(:ref)    { "ref" }
    let(:user)   { double }

    subject { pick_source.github_ref_exists?(user) }

    before do
      allow(pick_source).to receive(:github).and_return(github)
      allow(github).to receive(:reference).and_return(ref: ref)
    end

    it { should == true }
  end

  describe "#owner_branch" do
    
    subject { pick_source.owner_branch }

    let(:branch) { double(repo: repo) }
    let(:owner)  { double }
    let(:repo)   { double(owner: owner) }

    before do
      pick_source.branch = branch
      allow(pick_source).to receive(:github_ref_exists?).and_return(true)
    end

    it { should == owner }
  end

  describe "#pick" do

    subject { pick_source.pick }

    let(:build_branch) { double }

    before do
      allow(pick_source).to receive(:source_from_string_with_slashes)
      allow(pick_source).to receive(:source_from_owner)
      allow(pick_source).to receive(:source_from_string)
      allow(pick_source).to receive(:build_branch).and_return(build_branch)
    end

    it { should == build_branch }

    context "when repo is set" do
      
      before do
        pick_source.repo = true
        subject
      end

      specify { expect(pick_source).to have_received(:source_from_string_with_slashes) }
      specify { expect(pick_source).to_not have_received(:source_from_owner) }
      specify { expect(pick_source).to_not have_received(:source_from_string) }
    end

    context "when repo is not set" do
      
      before do
        pick_source.repo = nil
        subject
      end

      specify { expect(pick_source).to have_received(:source_from_string_with_slashes) }
      specify { expect(pick_source).to have_received(:source_from_owner) }
      specify { expect(pick_source).to have_received(:source_from_string) }
    end
  end

  describe "#source_from_owner" do

    let(:branch)       { double(repo:  repo) }
    let(:owner_branch) { double(login: "login") }
    let(:repo)         { double(name:  "name") }

    before { pick_source.branch = branch }

    subject { pick_source.source_from_owner }

    context "with owner branch" do

      before do
        allow(pick_source).to receive(:owner_branch).and_return(owner_branch)
        subject
      end

      specify { expect(pick_source.repo).to eq("login/name") }
    end

    context "without owner branch" do

      before do
        allow(pick_source).to receive(:owner_branch)
        subject
      end

      specify { expect(pick_source.repo).to_not eq("login/name") }
    end
  end

  describe "#source_from_string" do

    let(:branch) { double(repo: repo) }
    let(:repo)   { double(name: "name") }

    subject! { pick_source.source_from_string }

    specify { pick_source.repo.should == "name" }
  end

  describe "#source_from_string_with_slashes" do

    subject { pick_source.source_from_string_with_slashes }

    context "when source has slash" do

      before do
        pick_source.source = "repo/source"
        subject
      end

      specify { pick_source.repo.should   == "repo" }
      specify { pick_source.source.should == "source" }
    end

    context "when source has two slashes" do

      before do
        pick_source.source = "owner/repo/source"
        subject
      end
      
      specify { pick_source.repo.should   == "owner/repo" }
      specify { pick_source.source.should == "source" }
    end

    context "when source has no slashes" do

      before { pick_source.source = "source" }
      
      it { should == nil }
    end
  end
end