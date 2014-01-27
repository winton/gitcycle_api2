json.type "object"
json.additionalProperties false
json.properties do
  json.name { json.type "string" }
  json.user { json.partial! "schema/user" }
end