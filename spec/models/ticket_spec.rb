require 'spec_helper'

describe Ticket do

  it "should create a hash by ticket numbers" do
    hash = (0..9).inject({}) do |hash, number|
      hash[number] = Ticket.create!(number: number)
      hash
    end
    
    Ticket.hash_by_numbers(0..9).should eq(hash)
  end
end
