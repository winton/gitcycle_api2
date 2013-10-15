json.type "object"
json.properties do
  json.issue_url      { json.type "string" }
  json.lighthouse_url { json.type "string" }
  json.name           { json.type "string" }
  json.source         { json.type "string" }
  json.title          { json.type "string" }
  json.repo           { json.partial! "schema/repo" }
end