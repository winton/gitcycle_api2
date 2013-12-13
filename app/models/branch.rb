require "persist_changes"

class Branch < ActiveRecord::Base

  include PersistChanges

  after_commit :update_from_changes
  after_save   :update_from_changes  if Rails.env == 'test'

  attr_accessible :name, :source, :state, :title

  belongs_to :repo
  belongs_to :user

  validates_uniqueness_of :name, scope: [ :source, :user_id ]

  class <<self
    def find_from_params(params, user)
      if params[:name] || params[:branch]
        Branch.where(
          name:    params[:name] || params[:branch],
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
    self.repo = Repo.find_from_params(params[:repo])

    %w(github_url lighthouse_url source title).each do |attribute|
      send("#{attribute}=", params[attribute])  if params[attribute]
    end
    
    save
  end

  def create_pull_request
    self.github_url = Github.new(user).pull_request(self)[:issue_url]
    save
  end

  def lighthouse_url=(url)
    self.lighthouse_namespace, self.lighthouse_project_id, self.lighthouse_ticket_id =
      url.match(/:\/\/([^\.]+).+\/projects\/(\d+)\/tickets\/(\d+)/).to_a[1..3]
  end

  def lighthouse_url
    return nil  unless lighthouse_namespace && lighthouse_project_id && lighthouse_ticket_id
    [
      "https://#{lighthouse_namespace}.lighthouseapp.com",
      "projects/#{lighthouse_project_id}",
      "tickets/#{lighthouse_ticket_id}"
    ].join("/")
  end

  def github_url=(url)
    self.github_issue_id = url.match(/\/(pull|issues)\/(\d+)/).to_a[2]
  end

  def github_url
    return nil  unless repo && repo.owner && github_issue_id
    "https://github.com/#{repo.owner.login}/#{repo.name}/pull/#{github_issue_id}"
  end

  def update_from_changes
    reset_changes # makes test env same as production

    update_from_github      if was_changed?(:github_issue_id)
    update_from_lighthouse  if was_changed?(:lighthouse_ticket_id)
    update_from_title       if was_changed?(:title)
    
    update_all_changes
  end

  def update_from_github
    issue      = Github.new(user).issue(github_url)
    self.title = issue[:title]
  end

  def update_from_lighthouse
    user.update_nil_lighthouse_user_namespaces(lighthouse_namespace)
    
    lh_user = user.lighthouse_users.find_by(namespace: lighthouse_namespace)
    return  unless lh_user

    ticket = Lighthouse.new(lh_user).ticket(lighthouse_project_id, lighthouse_ticket_id)
    self.title = ticket[:title]
    self.body  = ticket[:body]
  end

  def update_from_title
    return  if self.name

    name        = title.downcase
    valid_chars = /[^\S\w-]/
    many_dashes = /-{2,}/

    name.gsub!(valid_chars, '-')
    name.gsub!(many_dashes, '-')

    if name.length > 30
      last_word = /-[^-]*$/
      name      = name[0..29].gsub(last_word, '')
    end

    self.name = name
  end
end
