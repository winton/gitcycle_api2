json.get do
  json.request do
    json.title "GET request /branch.json"
    json.type "object"
    json.additionalProperties false
    json.properties do
      json.name   { json.type "string"; json.optional true }
      json.source { json.type "string"; json.optional true }
    end
  end
  json.response do
    json.title "GET response /branch.json"
    json.partial! "schema/branch"
  end
end
json.post do
  json.request do
    json.title "POST request /branch.json"
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
    json.title "POST response /branch.json"
    json.partial! "schema/branch"
  end
end
json.put do
  json.request do
    json.title "PUT request /branch.json"
    json.type "object"
    json.additionalProperties false
    json.properties do
      json.home   { json.type "string" }
      json.name   { json.type "string" }
      json.source { json.type "string" }
    end
  end
  json.response do
    json.title "PUT response /branch.json"
    json.partial! "schema/branch"
  end
end