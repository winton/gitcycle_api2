class LighthouseProject < ActiveRecord::Base
  
  attr_accessible :namespace, :number, :token, :user_id

  def lighthouse
    @lighthouse ||= Lighthouse.new(self)
  end

  def update_from_api!(page=1, limit=100)
    api_tickets = lighthouse.recently_updated_tickets(page, limit)
    tickets     = Ticket.hash_by_numbers(api_tickets.collect(&:number))

    next_page =
      if api_tickets.last
        last_ticket = tickets[api_tickets.last.number]

        if last_ticket
          last_ticket.needs_update?(api_tickets.last)
        else
          true
        end
      end
    
    api_tickets.each do |api_ticket|
      ticket = tickets[api_ticket.number]
      
      if ticket
        ticket.update_attributes(api_ticket.to_attributes)
      else
        Ticket.create(api_ticket.to_attributes)
      end
    end

    update_from_api!(page + 1, limit)  if next_page
  end
end
