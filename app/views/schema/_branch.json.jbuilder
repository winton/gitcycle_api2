json.get do
  json.request do
    json.title "GET request /branch.json"
    json.type "object"
    json.properties do
      json.name   { json.type "string" }
      json.source { json.type "string" }
    end
  end
  json.response do
    json.title "GET response /branch.json"
    json.type "object"
    json.properties do
      json.issue_url      { json.type "string" }
      json.lighthouse_url { json.type "string" }
      json.name           { json.type "string" }
      json.source         { json.type "string" }
      json.title          { json.type "string" }
      json.repo           { json.partial! "schema/repo" }
    end
  end
end
json.post do
  json.request do
    json.title "POST request /branch.json"
    json.type "object"
    json.properties do
      json.lighthouse_url { json.type "string" }
      json.source         { json.type "string" }
    end
  end
end