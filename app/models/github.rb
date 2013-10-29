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

  def repo
    response = @http.get("/repos/#{@user.login}/#{@repo.name}").body
    JSON.parse(response, symbolize_names: true)
  end

  def user
    response = @http.get("/users/#{@user.login}").body
    JSON.parse(response, symbolize_names: true)
  end
end