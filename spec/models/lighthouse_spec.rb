require 'spec_helper'

describe Lighthouse do

  fixtures :lighthouse_projects, :lighthouse_users, :lighthouse_project_users, :users

  before :each do
    @project = lighthouse_projects(:default)
  end

  it "should retrieve information for the current user" do
    VCR.use_cassette('lighthouse') do
      profile = @project.lighthouse.user
      profile.should be_a(Lighthouse::User)
      profile.id.should be_a(Fixnum)
    end
  end

  it "should retrieve a list of recently updated tickets" do
    VCR.use_cassette('lighthouse') do
      tickets = @project.lighthouse.recently_updated_tickets(1, 10)
      
      tickets.should be_an(Array)
      tickets.length.should eq(10)
      tickets.first.should  be_a(Lighthouse::Ticket)
    end
  end
end