class Repo < ActiveRecord::Base

  attr_accessible :name

  belongs_to :user
  belongs_to :owner, :class_name => 'User'

  has_many :branches

  validates_uniqueness_of :name, :scope => :user_id

  def owner_repo
    owner.repos.where(name: name)
  end
end
