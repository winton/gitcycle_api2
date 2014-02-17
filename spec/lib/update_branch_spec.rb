require 'spec_helper'

describe UpdateBranch do

  let(:user) do
    FactoryGirl.create(:user)
  end

  describe "#from_track_params" do

    let(:track) { Track.new({}) }

    it "calls Track#find_branch" do
      track.should_receive(:find_branch).and_call_original
      UpdateBranch.new(user).from_track_params(track)
    end

    it "creates updaters" do
      UpdateBranch::UPDATERS.each do |path|
        klass_str = File.basename(path, ".rb").classify
        klass     = Object.const_get("UpdateBranch::#{klass_str}")
        updater   = double(klass_str)

        klass.should_receive(:new).ordered.and_return(updater)
        updater.should_receive(:update?).ordered.and_return(false)
      end
      
      UpdateBranch.new(user).from_track_params(track)
    end

    it "assigns user" do
      branch = UpdateBranch.new(user).from_track_params(track)
      expect(branch.user).to eq(user)
    end
  end
end