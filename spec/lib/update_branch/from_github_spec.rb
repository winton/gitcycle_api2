require 'spec_helper'

describe UpdateBranch::FromGithub do

  let(:branch) { UpdateBranch.new(user).from_track(track) }
  let(:track)  { Track.new(branch: "branch", source: "source") }
  let(:user)   { FactoryGirl.create(:user) }

  describe "#update?" do

    let(:update?) { UpdateBranch::FromGithub.new(branch).update? }

    context "github issue id changed" do

      before(:each) { branch.github_issue_id = 123 }

      it "returns true" do
        expect(update?).to eq(true)
      end
    end

    context "github issue id not changed" do

      it "returns false" do
        expect(update?).to eq(false)
      end
    end
  end

  describe "#update" do

    it "assigns the title" do
      b = track.build_branch
      b.save
      puts b.inspect
      branch.github_issue_id = 123
      puts branch.inspect
      puts branch.github_url.inspect
      # UpdateBranch::FromGithub.new(branch).update
    end
  end
end