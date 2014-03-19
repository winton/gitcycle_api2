require 'spec_helper'

describe Rpc do

  let(:rpc) { Rpc.new(nil, nil) }
  subject   { rpc }

  describe "#build_branch" do
    
    subject { rpc.build_branch }

    let(:build_with_external) { double }

    before do
      BuildBranch.
        any_instance.
        stub(:build_with_external).
        and_return(build_with_external)
    end

    it { should == build_with_external }
  end

  describe "#track" do

    let(:source_branch_repo_login) { double }
    let(:source_branch_repo_name)  { double }
    let(:source_branch_name)       { double }
    let(:branch_name)              { double }

    before do
      allow(rpc).to receive(:source_branch_repo_login).and_return(source_branch_repo_login)
      allow(rpc).to receive(:source_branch_repo_name).and_return(source_branch_repo_name)
      allow(rpc).to receive(:source_branch_name).and_return(source_branch_name)
      allow(rpc).to receive(:branch_name).and_return(branch_name)
    end

    subject! { rpc.track }

    it do
      should == {
        commands: [
          [
            "Git", :checkout_remote,
            source_branch_repo_login,
            source_branch_repo_name,
            source_branch_name,
            branch_name
          ]
        ]
      }
    end
  end
end