json.set! "branch.json" do
  json.get do
    json.request do
      json.title "GET branch.json (request)"
      json.type  "object"
      json.additionalProperties false
      json.properties do
        json.name   { json.type "string"; json.optional true }
        json.source { json.type "string"; json.optional true }
      end
    end
    json.response do
      json.title    "GET branch.json (response)"
      json.partial! "schema/branch"
    end
  end
  json.post do
    json.request do
      json.title "POST branch.json (request)"
      json.type "object"
      json.additionalProperties false
      json.properties do
        json.github_url     { json.type "string"; json.optional true }
        json.lighthouse_url { json.type "string"; json.optional true }
        json.source         { json.type "string" }
        json.title          { json.type "string"; json.optional true }
        json.partial!       "schema/repo"
      end
    end
    json.response do
      json.title    "POST branch.json (response)"
      json.partial! "schema/branch"
    end
  end
  json.put do
    json.request do
      json.title "PUT branch.json (request)"
      json.type "object"
      json.additionalProperties false
      json.properties do
        json.name     { json.type "string" }
        json.source   { json.type "string" }
      end
    end
    json.response do
      json.title    "PUT branch.json (response)"
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
json.set! "pull_request.json" do
  json.post do
    json.request do
      json.title "POST pull_request.json (request)"
      json.type  "object"
      json.additionalProperties false
      json.properties do
        json.branch   { json.type "string" }
        json.partial! "schema/repo"
      end
    end
    json.response do
      json.title    "POST pull_request.json (response)"
      json.partial! "schema/branch"
    end
  end
end