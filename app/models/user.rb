class User < ActiveRecord::Base

  attr_accessible :github, :gravatar, :login, :name
  
  has_many :github_projects
  has_many :lighthouse_users

  has_many :assigned_tickets,    :through => :lighthouse_users
  has_many :lighthouse_projects, :through => :lighthouse_users
  has_many :tickets,             :through => :lighthouse_users

  validates_presence_of   :gitcycle, :github, :login, :name
  validates_uniqueness_of :gitcycle, :github, :login

  before_validation do |user|
    begin
      token = SecureRandom.hex(8)
    end while User.where(gitcycle: token).first

    user.gitcycle ||= token
  end
end
