require 'spec_helper'

describe UpdateBranch do

  let(:branch)        { double(:branch) }
  let(:update_branch) { UpdateBranch.new(branch) }
  subject             { update_branch }

  describe "#update" do

    let(:updater)       { double(:updater, update?: true, update: true) }
    let(:updater_class) { double(:updater, new: updater) }

    before   { allow(UpdateBranch).to receive(:updaters).and_return([ updater_class ]) }
    subject! { update_branch.update }

    specify { expect(updater_class).to have_received(:new).with(branch) }
    specify { expect(updater).to have_received(:update) }

    it { should == branch }
  end
end