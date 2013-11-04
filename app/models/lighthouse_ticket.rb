class LighthouseTicket < ActiveRecord::Base
  
  attr_accessor   :assigned_lighthouse_id, :lighthouse_id
  attr_accessible :assigned_lighthouse_id, :lighthouse_id, :assigned_lighthouse_user_id, :body, :lighthouse_user_id, :number, :service, :ticket_created_at, :ticket_updated_at, :title, :url

  belongs_to :assigned_lighthouse_user, :class_name => 'LighthouseUser'
  belongs_to :lighthouse_user

  delegate :user, :to => :lighthouse_user, :allow_nil => true

  before_save do |ticket|
    if ticket.assigned_lighthouse_id
      ticket.assigned_lighthouse_user = LighthouseUser.where(
        lighthouse_id: ticket.assigned_lighthouse_id
      ).first_or_create
    end

    if ticket.lighthouse_id
      ticket.lighthouse_user = LighthouseUser.where(
        lighthouse_id: ticket.lighthouse_id
      ).first_or_create
    end
  end

  def needs_update?(api_ticket)
    ticket_updated_at != Time.parse(api_ticket.updated_at)
  end

  class <<self

    def hash_tickets_by_numbers(numbers)
      Hash[ LighthouseTicket.where(number: numbers).map { |t| [ t.number, t ] } ]
    end
  end
end