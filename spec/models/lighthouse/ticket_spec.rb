require 'spec_helper'

describe Lighthouse::Ticket do

  it "should retrieve a list of recently updated tickets" do
    VCR.use_cassette('lighthouse') do
      tickets = Lighthouse::Ticket.updated_tickets
      tickets.should be_an(Array)
      tickets.first.should be_a(Lighthouse::Ticket)
    end
  end

  it "should update database from recently updated tickets" do
    VCR.use_cassette('lighthouse') do
      Lighthouse::Ticket.should_receive(:update!).with(1).and_call_original
      Lighthouse::Ticket.should_receive(:update!).with(2).and_call_original
      Lighthouse::Ticket.should_receive(:update!).with(3)
      Lighthouse::Ticket.update!(1)
      
      Ticket.count.should eq(200)
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
end
