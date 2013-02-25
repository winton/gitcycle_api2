class User < ActiveRecord::Base
  attr_accessible :gitcycle, :github, :gravatar, :login, :name

  validates_presence_of :gitcycle, :github, :login, :name
  validates_uniqueness_of :gitcycle, :github, :login

  before_validation do |user|
    user.gitcycle ||= Digest::SHA1.hexdigest("#{id}#{github}")[0..7]
  end
end
