class User < ActiveRecord::Base

  attr_accessible :github, :gravatar, :login, :name
  
  has_many :branches
  has_many :lighthouse_users
  has_many :logs
  has_many :log_entries
  has_many :repos
  
  validates_presence_of   :gitcycle, :login
  validates_uniqueness_of :gitcycle, :login, :allow_nil => true

  before_validation do |user|
    begin
      token = SecureRandom.hex(4)
    end while User.where(gitcycle: token).first

    user.gitcycle ||= token
  end

  class <<self
    def find_from_params(params)
      if params.is_a?(self)
        params
      else params[:login]
        user = User.where(login: params[:login]).first_or_initialize
        user.name = params[:name]  if params[:name]
        user.update_name
        user
      end
    end
  end

  def update_nil_lighthouse_user_namespaces(namespace)
    lighthouse_users.where(namespace: nil).each do |lh_user|
      lh_user.namespace = namespace
      lh_user.save
    end
  end

  def update_name
    unless name
      github = Github.new(self)
      user   = github.user

      self.name = user[:name]
    end
    save
  end
end
