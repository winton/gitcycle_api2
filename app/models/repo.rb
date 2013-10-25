class Repo < ActiveRecord::Base

  belongs_to :user
  belongs_to :owner, :class_name => 'User'

  delegate :login, :to => :user

  has_many :branches

  validates :name, :user_id, uniqueness: true

  def owner_repo
    owner.repos.where(name: name)
  end
end
