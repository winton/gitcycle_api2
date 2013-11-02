require 'spec_helper'

describe LighthouseUser do

  fixtures :lighthouse_users, :users

  let(:user)    { users(:default) }
  let(:lh_user) { lighthouse_users(:default) }

  it "should have relationships" do
    user.lighthouse_users.count.should eq(1)
    user.lighthouse_users.first.should eq(lh_user)
    lh_user.user.should eq(user)
  end

  it "should create a hash of lighthouse users by lighthouse id" do
    hash = user.hash_lighthouse_users_by_lighthouse_id

    hash.should be_a(Hash)
    hash.keys.should   eq([ lh_user.lighthouse_id ])
    hash.values.should eq([ lh_user ])
  end

  it "should update database from recently updated tickets" do
    VCR.use_cassette('lighthouse') do
      lh_user.should_receive(:update_from_api!).with(6296, 1, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 2, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 3, 10)
      lh_user.update_from_api!(6296, 1, 10)
      
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
        ticket.lighthouse_user.should be_a(LighthouseUser)
      end
    end
  end

  it "should not go past the first page if last API result is not new" do
    VCR.use_cassette('lighthouse') do
      lh_user.should_receive(:update_from_api!).with(6296, 1, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 2, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 3, 10)
      lh_user.update_from_api!(6296, 1, 10)
      
      lh_user.should_receive(:update_from_api!).once.and_call_original
      lh_user.update_from_api!(6296, 1, 10)
    end
  end
end
