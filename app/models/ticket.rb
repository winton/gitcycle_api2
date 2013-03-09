class Ticket < ActiveRecord::Base
  
  attr_accessible :assigned_lighthouse_user_id, :body, :lighthouse_user_id, :number, :service, :ticket_created_at, :ticket_updated_at, :title, :url

  belongs_to :assigned_lighthouse_user, :class_name => 'LighthouseUser'
  belongs_to :lighthouse_project
  belongs_to :lighthouse_user

  delegate :user, :to => :lighthouse_user, :allow_nil => true

  def needs_update?(api_ticket)
    ticket_updated_at != Time.parse(api_ticket.updated_at)
  end

  class <<self

    def hash_by_numbers(numbers)
      Hash[ Ticket.where(number: numbers).map { |t| [ t.number, t ] } ]
    end
  end
end
