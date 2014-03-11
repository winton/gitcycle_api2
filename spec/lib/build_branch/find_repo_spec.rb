require 'spec_helper'

describe BuildBranch::FindRepo do

  let(:repo)      { "repo" }
  let(:user)      { double(id: 1) }
  let(:find_repo) { BuildBranch::FindRepo.new(repo, user) }
  subject         { find_repo }

  describe "#find" do

    subject { find_repo.find }

    let(:first_or_initialize) { double }
    let(:where) { double(first_or_initialize: first_or_initialize) }

    before do
      allow(find_repo).to receive(:repo_conditions)
      allow(Repo).to receive(:where).and_return(where)
    end

    it { should == first_or_initialize }
  end

  describe "#find_user" do

    subject { find_repo.find_user(nil) }

    let(:first_or_create) { double }
    let(:where) { double(first_or_create: first_or_create) }

    before { allow(User).to receive(:where).and_return(where) }

    it { should == first_or_create }
  end

  describe "#repo_conditions" do

    subject { find_repo.repo_conditions }

    context "when repo does not include a slash" do
      it { should == { name: repo, user_id: 1 } }
    end

    context "when repo includes a slash" do

      let(:login)     { "login" }
      let(:find_user) { double(id: 1) }

      before do
        find_repo.repo = "#{login}/#{repo}"
        allow(find_repo).to receive(:find_user).and_return(find_user)
        subject
      end

      specify { expect(find_repo).to have_received(:find_user).with(login) }

      it { should == { name: repo, user_id: 1 } }
    end
  end
end