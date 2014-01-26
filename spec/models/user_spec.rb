require 'spec_helper'

describe User do

  let(:user) do
    FactoryGirl.create(:user)
  end

  it "should generate gitcycle token if does not exist" do
    user.gitcycle = nil
    user.save
    user.gitcycle.should be_a(String)
    user.gitcycle.length.should eq(8)
  end
end
