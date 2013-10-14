json.type "object"
json.properties do
  json.name  { json.type "string" }
  json.owner { json.partial! "schema/user" }
  json.user  { json.partial! "schema/user" }
end