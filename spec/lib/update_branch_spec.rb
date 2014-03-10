require 'spec_helper'

describe UpdateBranch do

  subject { UpdateBranch.new(branch) }

  describe "#update" do

    let(:branch)        { double(:branch) }
    let(:updater)       { double(:updater, update?: true, update: true) }
    let(:updater_class) { double(:updater, new: updater) }

    before { allow(subject.class).to receive(:updaters).and_return([ updater_class ]) }
    before { subject.update }

    specify { expect(updater_class).to have_received(:new).with(branch) }
    specify { expect(updater).to have_received(:update) }
  end
end