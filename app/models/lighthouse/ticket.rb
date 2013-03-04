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

    def updated_tickets(page=1, limit=100)
      Lighthouse::Ticket.find(:all, params: {
        limit:      limit,
        page:       page,
        project_id: 6296,
        q:          'sort:updated'
      })
    end

    def update!(page=1, limit=100)
      updated = updated_tickets(page, limit)
      last    = updated.last
      tickets = Ticket.hash_by_numbers(updated.collect(&:number))

      next_page =
        if last
          if tickets[last.number]
            last.updated_at != tickets[last.number].ticket_updated_at
          else
            true
          end
        end
      
      updated.each do |ticket|
        attributes = ticket.to_attributes

        if t = tickets[ticket.number]
          t.update_attributes(attributes)
        else
          Ticket.create(attributes)
        end
      end

      update!(page + 1, limit) if next_page
    end
  end
end