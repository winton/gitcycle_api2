json.type "object"
json.additionalProperties false
json.properties do
  json.github_url     { json.type "string"; json.optional true }
  json.lighthouse_url { json.type "string"; json.optional true }
  json.name           { json.type "string" }
  json.source         { json.type "string" }
  json.title          { json.type "string" }
  json.repo           { json.partial! "schema/branch/repo" }
end