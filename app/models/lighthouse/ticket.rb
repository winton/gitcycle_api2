class Lighthouse::Ticket < Lighthouse::Base

  def to_attributes
    {
      body:              original_body_html,
      number:            number,
      service:           'lh',
      ticket_created_at: created_at,
      ticket_updated_at: updated_at,
      title:             title,
      url:               url
    }
  end

  class <<self

    def update!(page=1, limit=100)
      api_tickets = updated_tickets(page, limit)
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

      update!(page + 1, limit)  if next_page
    end

    def updated_tickets(page=1, limit=100)
      Lighthouse::Ticket.find(:all, params: {
        limit:      limit,
        page:       page,
        project_id: 6296,
        q:          'sort:updated'
      })
    end
  end
end