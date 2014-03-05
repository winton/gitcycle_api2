class Track < Struct.new(:params, :user)

  def branch_conditions
    where   = {}
    options = to_options
    
    if id = options[:id]
      where[:id] = id

    elsif name = options[:branch]
      where[:name] = name

    elsif options[:title]
      where[:title] = options[:title]
    
    elsif options[:lighthouse_url]
      where.merge! LighthouseUrl.new(options[:lighthouse_url]).to_conditions
    
    elsif options[:github_url]
      where.merge! GithubUrl.new(options[:github_url]).to_conditions
    end

    where
  end

  def build_branch
    branch  = find_branch
    options = to_options

    if options[:reset] && branch.id
      branch.destroy
      branch = find_branch
    end

    branch.user = user

    if options[:repo]
      branch.repo = find_repo
    end

    if options[:source]
      branch.source_branch = pick_source(branch)
    end

    branch
  end

  def find_branch
    Branch.where(branch_conditions).first_or_initialize
  end

  def find_repo
    Repo.where(repo_conditions).first_or_initialize
  end

  def owner_branch_exists?(branch)
    owner = branch.repo.owner
    ref   = Github.new(branch.repo, user).reference(owner, branch)
    owner if ref[:ref].present?
  end

  def parse_query(query)
    if query =~ /^https?:\/\//
      [ nil, nil, query ]
    elsif query =~ /\s/
      [ nil, query, nil ]
    else
      [ query, nil, nil ]
    end
  end

  def pick_source(branch)
    options = to_options

    if options[:source].include?("/")
      pieces = options[:source].split("/")
      source = pieces.pop
      repo   = pieces.join("/")
    elsif owner = owner_branch_exists?(branch)
      source = options[:source]
      repo   = "#{owner.login}/#{branch.repo.name}"
    else
      source = options[:source]
      repo   = branch.repo.name
    end

    self.class.new(branch: source, repo: repo).build_branch
  end
  
  def repo_conditions
    options = to_options
    u = user

    if options[:repo].include?("/")
      u, repo = options[:repo].split("/")
      u  = User.where(login: u).first_or_create
    else
      repo = options[:repo]
    end

    { name: repo, user_id: u.id }
  end

  def to_options
    branch, title, url = parse_query(params[:query])

    if branch
      options = { branch: branch }.merge(params)
    elsif url
      options = ticket_provider_option(url).merge(params)
    elsif title
      options = { title: title }.merge(params)
    else
      options = params.dup
    end

    options
  end

  def update_branch
    branch = build_branch
    branch = UpdateBranch.new(branch).update
    branch.save
    branch
  end

  def ticket_provider_option(url)
    if url.include?('lighthouseapp.com/')
      { :lighthouse_url => url }
    elsif url.include?('github.com/')
      { :github_url => url }
    end
  end
end