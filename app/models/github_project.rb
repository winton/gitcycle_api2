class GithubProject < ActiveRecord::Base
  
  attr_accessible :owner, :repo
end
