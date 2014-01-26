json.type "object"
json.additionalProperties false
json.properties do
  json.name { json.type "string" }
  json.repo { json.partial! "schema/repo" }
end