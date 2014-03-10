require 'spec_helper'

describe UpdateBranch::FromGithub do

  let(:branch) { double(:branch) }

  describe "#update?" do

    subject { UpdateBranch::FromGithub.new(branch).update? }

    context "github issue id changed" do

      before  { branch.stub(:github_issue_id_changed?).and_return(true) }
      it      { should == true }
    end

    context "github issue id not changed" do

      before  { branch.stub(:github_issue_id_changed?).and_return(false) }
      it      { should == false }
    end
  end
end