class Ticket < ActiveRecord::Base
  
  attr_accessible :body, :number, :service, :title, :url, :ticket_created_at, :ticket_updated_at

  class <<self

    def hash_by_numbers(numbers)
      Ticket.where(number: numbers).inject({}) do |hash, t|
        hash[t.number] = t
        hash
      end
    end
  end
end
