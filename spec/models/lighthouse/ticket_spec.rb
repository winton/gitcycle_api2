require 'spec_helper'

describe Lighthouse::Ticket do

  it "should retrieve a list of recently updated tickets" do
    VCR.use_cassette('lighthouse_01') do
      tickets = Lighthouse::Ticket.updated_tickets(1, 10)
      tickets.should        be_an(Array)
      tickets.length.should eq(10)
      tickets.first.should  be_a(Lighthouse::Ticket)
    end
  end

  it "should update database from recently updated tickets" do
    VCR.use_cassette('lighthouse_02') do
      Lighthouse::Ticket.should_receive(:update!).with(1, 10).and_call_original
      Lighthouse::Ticket.should_receive(:update!).with(2, 10).and_call_original
      Lighthouse::Ticket.should_receive(:update!).with(3, 10)
      Lighthouse::Ticket.update!(1, 10)
      
      Ticket.count.should eq(20)
      Ticket.all.each do |ticket|
        ticket.body.should    be_a(String)
        ticket.number.should  be_a(Fixnum)
        ticket.service.should be_a(String)
        ticket.ticket_created_at.should be_a(Time)
        ticket.ticket_updated_at.should be_a(Time)
        ticket.title.should be_a(String)
        ticket.url.should   be_a(String)
      end
    end
  end

  it "should not go past the first page if last API result is not new" do
    VCR.use_cassette('lighthouse_03') do
      Lighthouse::Ticket.should_receive(:update!).with(1, 10).and_call_original
      Lighthouse::Ticket.should_receive(:update!).with(2, 10).and_call_original
      Lighthouse::Ticket.should_receive(:update!).with(3, 10)
      Lighthouse::Ticket.update!(1, 10)
      
      Lighthouse::Ticket.should_receive(:update!).once.and_call_original
      Lighthouse::Ticket.update!(1, 10)
    end
  end
end
