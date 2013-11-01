class LighthouseProject < ActiveRecord::Base
  
  attr_accessible :namespace, :number, :token

  has_many :lighthouse_project_users
  has_many :lighthouse_users, :through => :lighthouse_project_users
  has_many :users,            :through => :lighthouse_users
  has_many :tickets

  class <<self
    def from_url(url, user)
      regex = /:\/\/([^\.]+)[\D]+(\d+)/
      
      namespace, number = url.match(regex).to_a[1..-1]
      return  unless namespace && number

      lh_project = where(namespace: namespace, number: number).first_or_initialize
      lh_user    = LighthouseUser.from_project(lh_project, user)
      return  unless lh_user

      if lh_project.new_record?
        lh_project.lighthouse_users << lh_user
        lh_project.save
      end

      [ lh_project, lh_user ]
    end
  end

  def hash_lighthouse_users_by_lighthouse_id
    Hash[ lighthouse_users.map { |user| [ user.lighthouse_id, user ] } ]
  end

  def lighthouse
    @lighthouse ||= Lighthouse.new(self, self.lighthouse_users.first)
  end

  def update_from_api!(page=1, limit=100)
    @api_tickets  = lighthouse.recently_updated_tickets(page, limit)
    @tickets_hash = Ticket.hash_tickets_by_numbers(@api_tickets.collect(&:number))
    @users_hash   = hash_lighthouse_users_by_lighthouse_id
    
    @api_tickets.each do |api_ticket|
      update_ticket_from_api(api_ticket)
    end

    update_from_api!(page + 1, limit)  if next_page?
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
      ticket = tickets.build(api_ticket.to_attributes)
    end

    ticket.assigned_lighthouse_user = assigned  if assigned
    ticket.lighthouse_user          = user      if user

    ticket.save
  end
end
