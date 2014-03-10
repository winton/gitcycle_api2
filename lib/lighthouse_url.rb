class LighthouseUrl < Struct.new(:url)

  def to_conditions
    namespace, project, ticket = to_properties
        
    {
      lighthouse_namespace:  namespace,
      lighthouse_project_id: project,
      lighthouse_ticket_id:  ticket
    }
  end

  def to_properties
    regex = /:\/\/([^\.]+).+\/projects\/(\d+)\/tickets\/(\d+)/
    url.match(regex).to_a[1..3]
  end
end