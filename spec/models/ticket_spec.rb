require 'spec_helper'

describe Ticket do

  fixtures :lighthouse_projects, :lighthouse_users, :lighthouse_project_users, :users

  it "should determine if a ticket needs to be updated" do
    VCR.use_cassette('lighthouse') do
      api_ticket = lighthouse_projects(:default).lighthouse.recently_updated_tickets(1, 1).first
      updated_at = Time.parse(api_ticket.updated_at)
      ticket     = Ticket.create!(ticket_updated_at: updated_at)

      # False check
      ticket.needs_update?(api_ticket).should eq(false)

      # True check
      ticket.ticket_updated_at = updated_at + 1
      ticket.needs_update?(api_ticket).should eq(true)
    end
  end

  it "should create a hash of tickets by ticket number" do
    hash = (0..9).inject({}) do |hash, number|
      hash[number] = Ticket.create!(number: number)
      hash
    end
    
    Ticket.hash_tickets_by_numbers(0..9).should eq(hash)
  end
end
