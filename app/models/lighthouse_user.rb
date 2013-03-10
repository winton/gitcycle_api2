class LighthouseUser < ActiveRecord::Base

  attr_accessible :lighthouse_id, :token, :user_id

  belongs_to :user

  has_many :assigned_tickets, :class_name => 'Ticket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_projects, :through => :lighthouse_project_users
  has_many :lighthouse_project_users
  has_many :tickets
end
