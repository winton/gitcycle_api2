class Repo < ActiveRecord::Base

  after_commit :update_owner
  after_save   :update_owner  if Rails.env == 'test'

  attr_accessible :name

  belongs_to :user
  belongs_to :owner, :class_name => 'User'

  has_many :branches

  validates_uniqueness_of :name, :scope => :user_id
  validates_presence_of   :name, :user_id

  def head
    "#{owner_or_user.login}:#{source}"
  end

  def owner_repo
    if owner
      owner.repos.where(name: name)
    else
      self
    end
  end

  def owner_or_user
    owner || user
  end

  def update_owner
    return  if owner_id

    github = Github.new(self)
    repo   = github.repo

    if repo[:parent]
      self.owner = User.where(
        login: repo[:parent][:owner][:login],
        name:  repo[:parent][:owner][:name]
      ).first_or_create
    end
    
    save
  end
end
