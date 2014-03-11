require 'spec_helper'

describe UpdateBranch::FromGithub do
  
  describe "#update?" do

    subject { UpdateBranch::FromGithub.new(branch).update? }

    context "github issue id changed" do

      let(:branch) { double(:branch, github_issue_id_changed?: true) }
      it { should == true }
    end

    context "github issue id not changed" do

      let(:branch) { double(:branch, github_issue_id_changed?: false) }
      it { should == false }
    end
  end
end