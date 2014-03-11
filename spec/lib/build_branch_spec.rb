require 'spec_helper'

describe BuildBranch do

  let(:params)       { double }
  let(:user)         { double }
  let(:build_branch) { BuildBranch.new(params, user) }

  subject { build_branch }

  describe "#build" do

    subject { build_branch.build }

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

      allow(find_branch).to receive(:user=)
      allow(find_branch).to receive(:repo=)
      allow(find_branch).to receive(:source_branch=)

      subject
    end

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
end