require 'spec_helper'

describe BuildBranch do

  let(:params)       { double }
  let(:user)         { double }
  let(:build_branch) { BuildBranch.new(params, user) }

  subject { build_branch }

  describe "#build" do

    let(:get_options)  { {} }
    let(:find_branch)  { double }
    let(:reset_branch) { double }
    let(:find_repo)    { double }
    let(:pick_source)  { double }

    before do
      allow(build_branch).to receive(:get_options).and_return(get_options)
      allow(build_branch).to receive(:find_branch).and_return(find_branch)
      allow(build_branch).to receive(:reset_branch).and_return(reset_branch)
      allow(build_branch).to receive(:find_repo).and_return(find_repo)
      allow(build_branch).to receive(:pick_source).and_return(pick_source)

      allow(find_branch).to receive(:new_record?).and_return(true)
      allow(find_branch).to receive(:user=)
      allow(find_branch).to receive(:repo=)
      allow(find_branch).to receive(:source_branch=)
    end

    subject! { build_branch.build }

    it { should == find_branch }

    context "all options present" do

      let(:get_options) { { repo: 'repo', reset: true, source: 'source' } }

      specify { expect(build_branch).to have_received(:get_options) }
      specify { expect(build_branch).to have_received(:find_branch) }
      specify { expect(build_branch).to have_received(:reset_branch) }
      specify { expect(build_branch).to have_received(:find_repo) }
      specify { expect(build_branch).to have_received(:pick_source) }

      specify { expect(find_branch).to have_received(:user=).with(user) }
      specify { expect(find_branch).to have_received(:repo=).with(find_repo) }
      specify { expect(find_branch).to have_received(:source_branch=).with(pick_source) }
    end

    context "no options present" do

      let(:get_options) { {} }

      specify { expect(build_branch).to have_received(:get_options) }
      specify { expect(build_branch).to have_received(:find_branch) }
      specify { expect(build_branch).to_not have_received(:reset_branch) }
      specify { expect(build_branch).to_not have_received(:find_repo) }
      specify { expect(build_branch).to_not have_received(:pick_source) }

      specify { expect(find_branch).to have_received(:user=).with(user) }
      specify { expect(find_branch).to_not have_received(:repo=).with(find_repo) }
      specify { expect(find_branch).to_not have_received(:source_branch=).with(pick_source) }
    end
  end

  describe "#build_with_external" do

    let(:update_branch) { double(save: true) }

    before do
      allow(build_branch).to receive(:update_branch).and_return(update_branch)
    end

    subject! { build_branch.build_with_external }
    specify  { expect(update_branch).to have_received(:save) }

    it { should == update_branch }
  end

  describe "#find_branch" do
    
    subject { build_branch.find_branch }

    let(:find) { double }

    before do
      BuildBranch::FindBranch.any_instance.stub(:find).and_return(find)
    end

    it { should == find }
  end

  describe "#find_repo" do
    
    subject { build_branch.find_repo }

    let(:find) { double }

    before do
      BuildBranch::FindRepo.any_instance.stub(:find).and_return(find)
    end

    it { should == find }
  end

  describe "#get_options" do
    
    subject { build_branch.get_options }

    let(:options) { double }

    before do
      BuildBranch::Options.any_instance.stub(:options).and_return(options)
    end

    it { should == options }
  end

  describe "#pick" do
    
    subject { build_branch.pick_source }

    let(:pick) { double }

    before do
      BuildBranch::PickSource.any_instance.stub(:pick).and_return(pick)
    end

    it { should == pick }
  end

  describe "#reset_branch" do
    
    let(:branch)      { double }
    let(:find_branch) { double }

    before do
      build_branch.branch = branch
      allow(branch).to receive(:id).and_return(1)
      allow(branch).to receive(:destroy)
      allow(build_branch).to receive(:find_branch).and_return(find_branch)
    end

    subject! { build_branch.reset_branch }
    specify  { expect(branch).to have_received(:id) }
    specify  { expect(branch).to have_received(:destroy) }
    specify  { expect(build_branch).to have_received(:find_branch) }

    it { should == find_branch }
  end

  describe "#update_branch" do
    
    subject { build_branch.update_branch }

    let(:update) { double }

    before do
      allow(build_branch).to receive(:build)
      UpdateBranch.any_instance.stub(:update).and_return(update)
    end

    it { should == update }
  end
end