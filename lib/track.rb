class Track < Struct.new(:params)

  def build_branch(user=nil)
    branch  = find_branch
    options = to_options

    branch.user = user  if user

    if options[:reset] && branch.id
      branch.destroy
      branch = find_branch
    end

    if options[:source]
      branch.source_branch =
        self.class.new(branch: options[:source]).find_branch
    end

    branch
  end

  def find_branch
    Branch.where(to_conditions).first_or_initialize
  end

  def to_conditions
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

  def update_branch(user=nil)
    branch = build_branch(user)
    UpdateBranch.new(branch).update
  end

  private

  def parse_query(query)
    if query =~ /^https?:\/\//
      [ nil, nil, query ]
    elsif query =~ /\s/
      [ nil, query, nil ]
    else
      [ query, nil, nil ]
    end
  end

  def ticket_provider_option(url)
    if url.include?('lighthouseapp.com/')
      { :lighthouse_url => url }
    elsif url.include?('github.com/')
      { :github_url => url }
    end
  end
end