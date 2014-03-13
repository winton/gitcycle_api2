class Branch < ActiveRecord::Base

  attr_accessible :name, :state, :title

  belongs_to :source_branch, class_name: 'Branch'
  belongs_to :repo
  belongs_to :user

  has_many :child_branches, foreign_key: 'source_branch_id', class_name: 'Branch'

  validates_uniqueness_of :name, scope: [ :user_id ]

  before_save :use_created_repo

  def base
    source_branch.name
  end

  def github_url=(url)
    self.github_issue_id = self.class.github_url_to_issue_id(url)
  end

  def github_url
    return nil  unless source_repo_user && github_issue_id
    "https://github.com/#{source_repo_user.login}/#{source_repo.name}/pull/#{github_issue_id}"
  end

  def head
    "#{repo.login}:#{name}"
  end

  def lighthouse_url=(url)
    self.lighthouse_namespace, self.lighthouse_project_id, self.lighthouse_ticket_id =
      self.class.lighthouse_url_to_properties(url)
  end

  def lighthouse_url
    return nil  unless lighthouse_namespace && lighthouse_project_id && lighthouse_ticket_id
    [
      "https://#{lighthouse_namespace}.lighthouseapp.com",
      "projects/#{lighthouse_project_id}",
      "tickets/#{lighthouse_ticket_id}"
    ].join("/")
  end

  def login
    user.login rescue nil
  end

  def serializable_hash(options={})
    options = { include: [ :repo, :source_branch ] }.update(options)

    super(options)
  end

  def source_repo_user
    source_branch.repo.user rescue nil
  end

  def source_repo
    source_branch.repo rescue nil
  end

  private

  def use_created_repo
    if repo && !repo.id && source_repo && source_repo.name == repo.name
      self.repo = self.source_repo
    end
  end
end
