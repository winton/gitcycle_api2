require 'spec_helper'

describe Rpc do

  let(:params) { double(:params) }
  let(:user)   { double(:user) }
  let(:rpc)    { Rpc.new(params, user) }
  subject      { rpc }

  describe "#track" do

    let(:build_branch)       { double(build_with_external: double) }
    let(:build_branch_class) { double(new: build_branch) }

    before   { stub_const("BuildBranch", build_branch_class) }
    subject! { rpc.track }

    it do
      should == {
        branch:   build_branch.build_with_external,
        commands: [ :checkout_from_remote ]
      }
    end
  end
end