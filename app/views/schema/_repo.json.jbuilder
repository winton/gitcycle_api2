json.type "object"
json.additionalProperties false
json.properties do
  json.name { json.type "string" }
  json.user do
    json.type "object"
    json.additionalProperties false
    json.properties do
      json.login { json.type "string" }
    end
  end
end