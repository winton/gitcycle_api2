class LighthouseProject < ActiveRecord::Base
  
  attr_accessible :namespace, :number, :token

  has_many :lighthouse_project_users
  has_many :lighthouse_users, :through => :lighthouse_project_users
  has_many :users,            :through => :lighthouse_users

  def hash_lighthouse_users_by_id
    Hash[ lighthouse_users.map { |user| [ user.lighthouse_id, user ] } ]
  end

  def lighthouse
    @lighthouse ||= Lighthouse.new(self)
  end

  def update_from_api!(page=1, limit=100)
    api_tickets = lighthouse.recently_updated_tickets(page, limit)
    tickets     = Ticket.hash_by_numbers(api_tickets.collect(&:number))
    users       = hash_lighthouse_users_by_id

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
      assigned = users[api_ticket.assigned_user_id]
      ticket   = tickets[api_ticket.number]
      user     = users[api_ticket.user_id]
      
      if ticket
        ticket.assign_attributes(api_ticket.to_attributes)
      else
        ticket = Ticket.new(api_ticket.to_attributes)
      end

      ticket.assigned_lighthouse_user = assigned  if assigned
      ticket.lighthouse_user          = user      if user

      ticket.save
    end

    update_from_api!(page + 1, limit)  if next_page
  end
end
