class Github

  def initialize(*args)
    @api_url = "https://api.github.com"

    @repo = args.detect { |a| a.is_a?(Repo) }
    @user = args.detect { |a| a.is_a?(User) } || @repo.user

    @http = Faraday.new @api_url, ssl: { verify: false } do |conn|
      conn.adapter  :excon
    end
    
    @http.headers['Authorization'] = "token #{@user.github}"
  end

  def issue(github_url)
    owner, repo, x, number =
      github_url.match(/\.com\/([^\/]+)\/([^\/]+)\/(issues|pull)\/(\d+)/).to_a[1..-1]
    
    response = @http.get("/repos/#{owner}/#{repo}/issues/#{number}").body
    JSON.parse(response, symbolize_names: true)
  end

  def pull_request(branch)
    response = @http.post(
      "/repos/#{@branch.source_repo_user.login}/#{@branch.source_repo.name}/pulls",
      title: branch.title,
      body:  branch.body,
      head:  branch.head,
      base:  branch.base
    ).body
    
    JSON.parse(response, symbolize_names: true)
  end

  def reference(user, source)
    response = @http.get("/repos/#{user.login}/#{@repo.name}/git/refs/heads/#{source}").body
    JSON.parse(response, symbolize_names: true)
  end

  def repo
    response = @http.get("/repos/#{@user.login}/#{@repo.name}").body
    JSON.parse(response, symbolize_names: true)
  end

  def user
    response = @http.get("/users/#{@user.login}").body
    JSON.parse(response, symbolize_names: true)
  end
end