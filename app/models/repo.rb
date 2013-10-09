class Repo < ActiveRecord::Base

  belongs_to :user
  belongs_to :owner, :class_name => 'User'

  has_many :branches
end
