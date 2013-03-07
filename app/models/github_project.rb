class GithubProject < ActiveRecord::Base
  attr_accessible :owner, :repo, :user_id
end
