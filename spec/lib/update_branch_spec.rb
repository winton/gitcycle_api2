require 'spec_helper'

describe UpdateBranch do

  let(:branch) { double(:branch) }
  subject      { UpdateBranch.new(branch) }

  describe "#update" do

    let(:updater)       { double(:updater, update?: true, update: true) }
    let(:updater_class) { double(:updater, new: updater) }

    before  { allow(UpdateBranch).to receive(:updaters).and_return([ updater_class ]) }
    before  { subject }
    subject { UpdateBranch.new(branch).update }

    specify { expect(updater_class).to have_received(:new).with(branch) }
    specify { expect(updater).to have_received(:update) }

    it { should == branch }
  end
end