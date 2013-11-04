require "persist_changes"

class Branch < ActiveRecord::Base

  include PersistChanges

  after_commit :update_from_changes
  after_save   :update_from_changes  if Rails.env == 'test'

  attr_accessible :github_url, :lighthouse_url, :source, :title

  belongs_to :repo
  belongs_to :user

  validates_uniqueness_of :name, scope: [ :source, :user_id ]

  class <<self
    def find_from_params(params, user)
      if params[:name]
        Branch.where(
          name:    params[:name],
          user_id: user.id
        ).first_or_initialize
      elsif params[:source]
        Branch.where(
          source:  params[:source],
          user_id: user.id
        ).first_or_initialize
      end
    end
  end

  def create_from_params(params)
    return unless new_record?

    self.repo = Repo.where(
      name: params[:repo][:name]
    ).first_or_initialize

    self.repo.user = User.where(
      login: params[:repo][:user][:login]
    ).first_or_create

    update_attributes(
      github_url:     params[:github_url],
      lighthouse_url: params[:lighthouse_url],
      source:         params[:source],
      title:          params[:title]
    )
  end

  def update_from_changes
    reset_changes
    update_from_github      if was_changed?(:github_url)
    update_from_lighthouse  if was_changed?(:lighthouse_url)
    update_from_title       if was_changed?(:title)
    update_all_changes
  end

  def update_from_github
    issue = Github.new(user).issue(github_url)
    self.title = issue[:title]
  end

  def update_from_lighthouse
    lh_user = user.lighthouse_user_from_url(lighthouse_url)
    return  unless lh_user

    ticket = Lighthouse.new(lh_user).ticket(lighthouse_url)
    self.title  = ticket[:title]
  end

  def update_from_title
    self.name = title
  end
end
