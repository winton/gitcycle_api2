require 'spec_helper'

describe BuildBranch::FindBranch do

  let(:find_branch) { BuildBranch::FindBranch.new({}) }

  subject { find_branch }

  describe "#branch_conditions" do

    subject { find_branch.branch_conditions }

    context "with id option" do

      let(:id) { 1 }
      before   { find_branch.options = { id: id } }
      it       { should == { id: id } }
    end

    context "with branch option" do

      let(:branch) { "branch" }
      before       { find_branch.options = { branch: branch } }
      it           { should == { name: branch } }
    end

    context "with title option" do

      let(:title) { "title" }
      before      { find_branch.options = { title: title } }
      it          { should == { title: title } }
    end

    context "with lighthouse_url option" do

      let(:lighthouse_conditions) { { worked: true } }

      before do
        find_branch.options = { lighthouse_url: "" }
        allow(find_branch).to receive(:lighthouse_conditions).and_return(lighthouse_conditions)
      end

      it { should == lighthouse_conditions }
    end

    context "with github_url option" do

      let(:github_conditions) { { worked: true } }

      before do
        find_branch.options = { github_url: "" }
        allow(find_branch).to receive(:github_conditions).and_return(github_conditions)
      end

      it { should == github_conditions }
    end
  end

  describe "#find" do

    subject { find_branch.find }

    let(:first_or_initialize) { double }
    let(:where) { double(first_or_initialize: first_or_initialize) }

    before { allow(Branch).to receive(:where).and_return(where) }

    it { should == first_or_initialize }
  end

  describe "#github_conditions" do

    subject { find_branch.github_conditions }

    let(:to_conditions) { double }

    before { GithubUrl.any_instance.stub(:to_conditions).and_return(to_conditions) }

    it { should == to_conditions }
  end

  describe "#lighthouse_conditions" do

    subject { find_branch.lighthouse_conditions }

    let(:to_conditions) { double }

    before { LighthouseUrl.any_instance.stub(:to_conditions).and_return(to_conditions) }

    it { should == to_conditions }
  end
end