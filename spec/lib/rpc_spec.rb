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

    let(:build_branch) { double }

    before do
      allow(rpc).to receive(:build_branch).and_return(build_branch)
    end

    subject! { rpc.track }

    it do
      should == {
        branch:   build_branch,
        commands: [ :checkout_from_remote ]
      }
    end
  end
end