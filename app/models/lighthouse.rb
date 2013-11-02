class Lighthouse

  def initialize(*args)
    @user    = args.detect { |a| a.is_a?(LighthouseUser) }
    @api_url = "https://#{@user.namespace}.lighthouseapp.com"

    @http = Faraday.new @api_url, ssl: { verify: false } do |conn|
      conn.adapter :excon
    end
    
    @http.headers['X-LighthouseToken'] = @user.token
  end

  def memberships
    response = @http.get("/users/#{@user.lighthouse_id}/memberships.json").body
    JSON.parse(response, symbolize_names: true)[:memberships]
  end

  def projects
    response = @http.get("/projects.json").body
    JSON.parse(response, symbolize_names: true)[:projects]
  end

  def recently_updated_tickets(project_id, page=1, limit=100)
    response = @http.get(
      "/projects/#{project_id}/tickets.json",
      limit: limit,
      page:  page,
      q:     'sort:updated'
    ).body

    response = JSON.parse(response)
    response['tickets'].collect do |t|
      Lighthouse::Ticket.new(t['ticket'])
    end
  end

  def ticket(project_id, ticket_id)
    ticket_id = ticket_id.match(/\/tickets\/(\d+)/).to_a[1]  if ticket_id =~ /\/tickets\//
    response = @http.get("/projects/#{project_id}/tickets/#{ticket_id}.json").body
    JSON.parse(response, symbolize_names: true)[:ticket]
  end

  def user
    response = @http.get("/profile.json").body
    response = JSON.parse(response)
    Lighthouse::User.new(response['user'])
  end
end