class Repo < ActiveRecord::Base

  attr_accessible :name

  belongs_to :user

  has_many :branches

  validates_uniqueness_of :name, scope: :user_id
  validates_presence_of   :name, :user_id

  class <<self
    def find_from_params(params)
      if params[:user]
        user = User.find_from_params(params[:user])
      end

      if params[:name] && user
        Repo.where(
          name:    params[:name],
          user_id: user.id
        ).first_or_initialize
      end
    end
  end

  def login
    user.login rescue nil
  end

  def owner
    github = Github.new(self)
    repo   = github.repo

    if repo[:parent]
      User.where(
        login: repo[:parent][:owner][:login],
        name:  repo[:parent][:owner][:name]
      ).first_or_initialize
    end
  end
end
