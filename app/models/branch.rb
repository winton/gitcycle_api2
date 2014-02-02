class Branch < ActiveRecord::Base

  attr_accessible :name, :state, :title

  belongs_to :source_branch, class_name: 'Branch'
  belongs_to :repo
  belongs_to :user

  has_many :child_branches, foreign_key: 'source_branch_id', class_name: 'Branch'

  validates_uniqueness_of :name, scope: [ :user_id ]

  class <<self
    def find_from_params(params, user=nil)
      params[:user] = user  if user

      where  = params_to_conditions(params)
      branch = Branch.where(where).first_or_initialize
      
      branch.build_from_params(params)
      branch
    end

    def github_conditions(url)
      { github_issue_id: github_url_to_issue_id(url) }
    end

    def github_url_to_issue_id(url)
      url.match(/\/(pull|issues)\/(\d+)/).to_a[2]
    end

    def lighthouse_conditions(url)
      namespace, project, ticket =
        lighthouse_url_to_properties(url)
          
      {
        lighthouse_namespace:  namespace,
        lighthouse_project_id: project,
        lighthouse_ticket_id:  ticket
      }
    end

    def lighthouse_url_to_properties(url)
      url.match(/:\/\/([^\.]+).+\/projects\/(\d+)\/tickets\/(\d+)/).to_a[1..3]
    end

    def params_to_conditions(params)
      where = {}
      
      if name = (params[:name] || params[:branch])
        where[:name] = name

      elsif params[:title]
        where[:title] = params[:title]
      
      elsif params[:lighthouse_url]
        where.merge! lighthouse_conditions(params[:lighthouse_url])
      
      elsif params[:github_url]
        where.merge! github_conditions(params[:github_url])
      end

      where
    end
  end

  def base
    source_branch.name
  end

  def build_from_params(params)
    if params[:repo]
      self.repo ||= Repo.find_from_params(params[:repo])
    end

    if params[:source_branch] != false
      self.source_branch ||= find_source_branch_from_params(
        params[:source_branch]
      )
    end

    if params[:user]
      self.user ||= User.find_from_params(params[:user])
    end

    %w(github_url lighthouse_url name title).each do |attribute|
      send("#{attribute}=", params[attribute])  if params[attribute]
    end

    update_from_changes
  end

  def create_from_params(params)
    build_from_params(params)
    save
  end

  def create_pull_request
    self.github_url = Github.new(user).pull_request(self)[:issue_url]
    save
  end

  def github_url=(url)
    self.github_issue_id = self.class.github_url_to_issue_id(url)
  end

  def github_url
    return nil  unless source_repo_user && github_issue_id
    "https://github.com/#{source_repo_user.login}/#{source_repo.name}/pull/#{github_issue_id}"
  end

  def find_source_branch_from_params(params)
    params ||= {}
    
    params[:name] ||= self.name
    params[:source_branch] = false

    pick_source_branch_repo(params, repo)
    Branch.find_from_params(params)
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

  def pick_source_branch_repo(params, repo)
    params[:repo] ||= {}
    params[:repo][:name] ||= repo.name
    params[:repo][:user] ||= {}

    unless params[:repo][:user][:login]
      user = [ repo.owner, repo.user ].detect do |u|
        repo.ref_exists?(u, self.name)
      end
      if user
        params[:repo][:user][:login] = user.login
        params[:repo][:user][:name]  = user.name
      end
    end
  end

  def source_repo_user
    source_branch.repo.user rescue nil
  end

  def source_repo
    source_branch.repo rescue nil
  end

  private

  def update_from_changes
    update_from_github      if github_issue_id_changed?
    update_from_lighthouse  if lighthouse_ticket_id_changed?
    update_from_title       if title_changed?
  end

  def update_from_github
    return  unless user

    issue      = Github.new(user).issue(github_url)
    self.title = issue[:title]
  end

  def update_from_lighthouse
    return  unless user
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
    valid_chars = /[^a-zA-Z]/
    many_dashes = /-{2,}/
    wrong_dash  = /^-|-$/

    name.gsub!(valid_chars, '-')
    name.gsub!(many_dashes, '-')
    name.gsub!(wrong_dash,  '')

    if name.length > 30
      last_word = /-[^-]*$/
      name      = name[0..29].gsub(last_word, '')
    end

    self.name = name
  end
end
