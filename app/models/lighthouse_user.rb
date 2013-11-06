class LighthouseUser < ActiveRecord::Base

  include PersistChanges

  after_commit :update_lighthouse_id
  after_save   :update_lighthouse_id if Rails.env == 'test'

  attr_accessible :lighthouse_id, :namespace, :token, :user_id

  belongs_to :user

  has_many :assigned_lighthouse_tickets, :class_name => 'LighthouseTicket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_tickets

  def namespaces
    memberships = Lighthouse.new(self).memberships
    namespaces  = memberships.map do |membership|
      if membership[:account]
        membership[:account].match(/([^\/]+)\.lighthouseapp\.com/)[1]
      end
    end.compact
  end

  def update_from_api!(project_id, page=1, limit=100)
    @api_tickets  = Lighthouse.new(self).recently_updated_tickets(project_id, page, limit)
    @tickets_hash = LighthouseTicket.hash_tickets_by_numbers(
      @api_tickets.collect { |t| t[:number] }
    )
    @users_hash   = user.hash_lighthouse_users_by_lighthouse_id
    
    @api_tickets.each do |api_ticket|
      update_ticket_from_api(api_ticket)
    end

    update_from_api!(project_id, page + 1, limit)  if next_page?
  end

  def update_lighthouse_id
    return if lighthouse_id
    reset_changes # makes test env same as production

    self.lighthouse_id = Lighthouse.new(self).user[:id]
    update_all_changes
  end

  private

  def next_page?
    if @api_tickets.last
      last_ticket = @tickets_hash[@api_tickets.last[:number]]

      if last_ticket
        last_ticket.needs_update?(@api_tickets.last)
      else
        true
      end
    end
  end

  def update_ticket_from_api(api_ticket)
    assigned   = @users_hash[api_ticket[:assigned_user_id]]
    ticket     = @tickets_hash[api_ticket[:number]]
    user       = @users_hash[api_ticket[:user_id]]
    attributes = LighthouseTicket.to_attributes(api_ticket)
    
    if ticket
      ticket.assign_attributes(attributes)
    else
      ticket = lighthouse_tickets.build(attributes)
    end

    ticket.assigned_lighthouse_user = assigned  if assigned
    ticket.lighthouse_user          = user      if user

    ticket.save
  end
end
