class LighthouseUser < ActiveRecord::Base

  attr_accessible :lighthouse_id, :token, :user_id

  belongs_to :user

  has_many :assigned_tickets, :class_name => 'Ticket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_projects, :through => :lighthouse_project_users
  has_many :lighthouse_project_users
  has_many :tickets

  class <<self
    def from_project(lh_project, user)
      unless lh_project.new_record?
        lh_user = lh_project.lighthouse_users.find_by(user_id: user.id)
      end

      lh_user || user.lighthouse_users.detect do |lh_user|
        Lighthouse.new(lh_user).memberships.detect do |membership|
          membership[:account] &&
          membership[:account] =~ /\/\/#{Regexp.quote(lh_project.namespace)}\./
        end
      end
    end
  end
end
