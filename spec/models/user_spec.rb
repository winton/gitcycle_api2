require 'spec_helper'

describe User do

  fixtures :users

  it "should generate gitcycle token if does not exist" do
    user = users(:default)
    user.gitcycle = nil
    user.save
    user.gitcycle.should be_a(String)
    user.gitcycle.length.should eq(8)
  end
end
