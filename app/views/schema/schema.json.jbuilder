json.set! "branch.json" do
  json.get do
    json.request do
      json.title "GET branch.json (request)"
      json.type "object"
      json.additionalProperties false
      json.properties do
        json.name   { json.type "string"; json.optional true }
        json.source { json.type "string"; json.optional true }
      end
    end
    json.response do
      json.title "GET branch.json (response)"
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
      end
    end
    json.response do
      json.title "POST branch.json (response)"
      json.partial! "schema/branch"
    end
  end
  json.put do
    json.request do
      json.title "PUT branch.json (request)"
      json.type "object"
      json.additionalProperties false
      json.properties do
        json.home   { json.type "string" }
        json.name   { json.type "string" }
        json.source { json.type "string" }
      end
    end
    json.response do
      json.title "PUT branch.json (response)"
      json.partial! "schema/branch"
    end
  end
end