class User < ActiveRecord::Base

  attr_accessible :github, :gravatar, :login, :name
  
  has_many :branches
  has_many :github_projects
  has_many :lighthouse_users
  has_many :owned_repos, :class_name => 'Repo', :foreign_key => 'owner_id'
  has_many :repos

  has_many :assigned_tickets,    :through => :lighthouse_users
  has_many :lighthouse_projects, :through => :lighthouse_users
  has_many :tickets,             :through => :lighthouse_users

  validates_presence_of   :gitcycle, :login
  validates_uniqueness_of :gitcycle, :login

  before_validation do |user|
    begin
      token = SecureRandom.hex(4)
    end while User.where(gitcycle: token).first

    user.gitcycle ||= token
  end
end
