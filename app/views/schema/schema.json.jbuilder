json.set! "track.json" do
  json.put do
    json.request do
      json.title "PUT track.json (request)"
      json.type  "object"
      json.additionalProperties false
      json.required []
      json.properties do
        json.branch         { json.type "string" }
        json.github_url     { json.type "string" }
        json.id             { json.type "string" }
        json.lighthouse_url { json.type "string" }
        json.query          { json.type "string" }
        json.reset          { json.type "string" }
        json.source         { json.type "string" }
        json.title          { json.type "string" }
      end
    end
    
    json.response do
      json.title "PUT track.json (response)"
      json.type  "object"
      json.additionalProperties false
      json.properties do
        json.branch   { json.partial! "schema/branch" }
        json.commands { json.partial! "schema/commands" }
      end
    end
  end
end

json.set! "logs.json" do
  json.post do
    json.request do
      json.title "POST logs.json (request)"
      json.type  "object"
      json.additionalProperties false
      json.properties do
        json.events do
          json.type  "array"
          json.items do
            json.type  "object"
            json.additionalProperties false
            json.properties do
              json.event      { json.type "string" }
              json.body       { json.type "string" }
              json.backtrace  { json.type "string" }
              json.ran_at     { json.type "integer" }
            end
          end
        end
      end
    end

    json.response do
      json.title "POST logs.json (response)"
      json.type  "object"
      json.additionalProperties false
      json.properties do
        json.id { json.type "string" }
      end
    end
  end
end

json.set! "pull_request.json" do
  json.post do
    json.request do
      json.title "POST pull_request.json (request)"
      json.type  "object"
      json.additionalProperties false
      json.properties do
        json.branch { json.type "string" }
        json.ready  { json.type "string"; json.enum [ "true", "false" ] }
        json.repo   { json.partial! "schema/repo" }
      end
    end

    json.response do
      json.title    "POST pull_request.json (response)"
      json.partial! "schema/branch"
    end
  end
end

json.set! "setup/lighthouse.json" do
  json.get do
    json.request do
      json.title "POST setup/lighthouse.json (request)"
      json.type  "object"
      json.additionalProperties false
      json.properties do
        json.token { json.type "string" }
      end
    end

    json.response do
      json.title "POST setup/lighthouse.json (response)"
      json.type  "null"
      json.additionalProperties false
    end
  end
end