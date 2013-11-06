require 'spec_helper'

describe LighthouseTicket do

  fixtures :lighthouse_users, :users

  let(:lh_user) { lighthouse_users(:default) }

  it "should determine if a ticket needs to be updated" do
    VCR.use_cassette('lighthouse') do
      api_ticket = Lighthouse.new(lh_user).recently_updated_tickets(6296, 1, 1).first
      updated_at = Time.parse(api_ticket[:updated_at])
      ticket     = LighthouseTicket.create!(ticket_updated_at: updated_at)

      # False check
      ticket.needs_update?(api_ticket).should eq(false)

      # True check
      ticket.ticket_updated_at = updated_at + 1
      ticket.needs_update?(api_ticket).should eq(true)
    end
  end

  it "should create a hash of tickets by ticket number" do
    hash = (0..9).inject({}) do |hash, number|
      hash[number] = LighthouseTicket.create!(number: number)
      hash
    end
    
    LighthouseTicket.hash_tickets_by_numbers(0..9).should eq(hash)
  end
end
