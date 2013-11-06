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

  def build_lighthouse_users_from_token(token)
    lighthouse_user = LighthouseUser.new(token: token)
    lighthouse_user.update_lighthouse_id

    namespaces = lighthouse_user.namespaces

    lighthouse_users.where(token: token).delete_all
    lighthouse_users.where(namespace: namespaces).delete_all
    
    namespaces.each do |namespace|
      lighthouse_users.create(
        namespace: namespace,
        token:     token
      )
    end
  end

  def hash_lighthouse_users_by_lighthouse_id
    Hash[ lighthouse_users.map { |user| [ user.lighthouse_id, user ] } ]
  end

  def lighthouse_user_from_url(url)
    regex = /:\/\/([^\.]+)[\D]+(\d+)/
    
    namespace, number = url.match(regex).to_a[1..-1]
    return  unless namespace && number

    lighthouse_users.find_by(namespace: namespace)
  end

  def update_name
    return  if name

    github = Github.new(self)
    user   = github.user

    self.name = user[:name]
    save
  end
end
