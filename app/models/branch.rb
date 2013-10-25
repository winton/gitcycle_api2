class Branch < ActiveRecord::Base

  belongs_to :repo
  belongs_to :user

  validates :name, :source, :user_id, uniqueness: true
end
