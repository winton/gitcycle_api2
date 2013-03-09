class Github

  def initialize(project)
    @api_url = "https://api.github.com"
    @project = project

    @http = Faraday.new @api_url, ssl: { verify: false } do |conn|
      conn.adapter  :excon
    end
    
    @http.headers['Authorization'] = "token #{project.user.github}"
  end
end