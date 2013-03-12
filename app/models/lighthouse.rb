class Lighthouse

  def initialize(project)
    @api_url = "https://#{project.namespace}.lighthouseapp.com"
    @project = project

    @http = Faraday.new @api_url, ssl: { verify: false } do |conn|
      conn.adapter :excon
    end
    
    @http.headers['X-LighthouseToken'] = project.lighthouse_users.first.token
  end

  def recently_updated_tickets(page=1, limit=100)
    response = @http.get(
      "/projects/#{@project.number}/tickets.json",
      limit: limit,
      page:  page,
      q:     'sort:updated'
    ).body

    response = JSON.parse(response)
    response['tickets'].collect do |t|
      Lighthouse::Ticket.new(t['ticket'])
    end
  end

  def user
    response = @http.get("/profile.json").body
    response = JSON.parse(response)
    Lighthouse::User.new(response['user'])
  end
end