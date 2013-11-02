class LighthouseUser < ActiveRecord::Base

  attr_accessible :lighthouse_id, :namespace, :token, :user_id

  belongs_to :user

  has_many :assigned_lighthouse_tickets, :class_name => 'LighthouseTicket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_tickets

  def update_from_api!(project_id, page=1, limit=100)
    @api_tickets  = Lighthouse.new(self).recently_updated_tickets(project_id, page, limit)
    @tickets_hash = LighthouseTicket.hash_tickets_by_numbers(@api_tickets.collect(&:number))
    @users_hash   = user.hash_lighthouse_users_by_lighthouse_id
    
    @api_tickets.each do |api_ticket|
      update_ticket_from_api(api_ticket)
    end

    update_from_api!(project_id, page + 1, limit)  if next_page?
  end

  private

  def next_page?
    if @api_tickets.last
      last_ticket = @tickets_hash[@api_tickets.last.number]

      if last_ticket
        last_ticket.needs_update?(@api_tickets.last)
      else
        true
      end
    end
  end

  def update_ticket_from_api(api_ticket)
    assigned = @users_hash[api_ticket.assigned_user_id]
    ticket   = @tickets_hash[api_ticket.number]
    user     = @users_hash[api_ticket.user_id]
    
    if ticket
      ticket.assign_attributes(api_ticket.to_attributes)
    else
      ticket = lighthouse_tickets.build(api_ticket.to_attributes)
    end

    ticket.assigned_lighthouse_user = assigned  if assigned
    ticket.lighthouse_user          = user      if user

    ticket.save
  end
end
