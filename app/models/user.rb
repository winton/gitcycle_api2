class User < ActiveRecord::Base

  after_commit :update_name
  after_save   :update_name  if Rails.env == 'test'

  attr_accessible :github, :gravatar, :login, :name
  
  has_many :branches
  has_many :github_projects
  has_many :lighthouse_users
  has_many :owned_repos, :class_name => 'Repo', :foreign_key => 'owner_id'
  has_many :repos

  has_many :assigned_lighthouse_tickets, :through => :lighthouse_users
  has_many :lighthouse_tickets,          :through => :lighthouse_users

  validates_presence_of   :gitcycle, :login
  validates_uniqueness_of :gitcycle, :login

  before_validation do |user|
    begin
      token = SecureRandom.hex(4)
    end while User.where(gitcycle: token).first

    user.gitcycle ||= token
  end

  class <<self
    def find_from_params(params)
      if params[:login]
        User.where(login: params[:login]).first_or_create
      end
    end
  end

  def hash_lighthouse_users_by_lighthouse_id
    Hash[ lighthouse_users.map { |user| [ user.lighthouse_id, user ] } ]
  end

  def update_name
    return  if name

    github = Github.new(self)
    user   = github.user

    self.name = user[:name]
    save
  end

  def update_nil_lighthouse_user_namespaces(namespace)
    lighthouse_users.where(namespace: nil).each do |lh_user|
      lh_user.namespace = namespace
      lh_user.save
    end
  end
end
