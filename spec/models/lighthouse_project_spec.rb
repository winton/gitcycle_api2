require 'spec_helper'

describe LighthouseProject do

  fixtures :lighthouse_projects, :lighthouse_users, :lighthouse_project_users, :users

  before :each do
    @project = lighthouse_projects(:default)
  end

  it "should have relationships" do
    @project.lighthouse_project_users.count.should eq(1)
    @project.lighthouse_users.count.should eq(1)
    @project.users.count.should eq(1)
  end

  it "should create a hash of lighthouse users by lighthouse id" do
    hash = @project.hash_lighthouse_users_by_lighthouse_id
    user = @project.lighthouse_users.first

    hash.should be_a(Hash)
    hash.keys.should   eq([ user.lighthouse_id ])
    hash.values.should eq([ user ])
  end

  it "should update database from recently updated tickets" do
    VCR.use_cassette('lighthouse') do
      @project.should_receive(:update_from_api!).with(1, 10).and_call_original
      @project.should_receive(:update_from_api!).with(2, 10).and_call_original
      @project.should_receive(:update_from_api!).with(3, 10)
      @project.update_from_api!(1, 10)
      
      Ticket.count.should eq(20)
      Ticket.all.each do |ticket|
        ticket.body.should    be_a(String)
        ticket.number.should  be_a(Fixnum)
        ticket.service.should be_a(String)
        ticket.ticket_created_at.should be_a(Time)
        ticket.ticket_updated_at.should be_a(Time)
        ticket.title.should be_a(String)
        ticket.url.should   be_a(String)

        ticket.assigned_lighthouse_user.should be_a(LighthouseUser)
        ticket.lighthouse_project.should be_a(LighthouseProject)
        ticket.lighthouse_user.should be_a(LighthouseUser)
      end
    end
  end

  it "should not go past the first page if last API result is not new" do
    VCR.use_cassette('lighthouse') do
      @project.should_receive(:update_from_api!).with(1, 10).and_call_original
      @project.should_receive(:update_from_api!).with(2, 10).and_call_original
      @project.should_receive(:update_from_api!).with(3, 10)
      @project.update_from_api!(1, 10)
      
      @project.should_receive(:update_from_api!).once.and_call_original
      @project.update_from_api!(1, 10)
    end
  end
end
