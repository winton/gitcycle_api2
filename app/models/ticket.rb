class Ticket < ActiveRecord::Base
  
  attr_accessible :body, :number, :service, :title, :url, :ticket_created_at, :ticket_updated_at

  def needs_update?(api_ticket)
    ticket_updated_at != Time.parse(api_ticket.updated_at)
  end

  class <<self

    def hash_by_numbers(numbers)
      Ticket.where(number: numbers).inject({}) do |hash, t|
        hash[t.number] = t
        hash
      end
    end
  end
end
