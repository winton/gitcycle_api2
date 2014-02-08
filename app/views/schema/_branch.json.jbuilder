is_source_branch ||= false

json.type "object"
json.additionalProperties false
json.optional true
json.required []
json.properties do
  json.id              { json.type "integer" }
  json.github_issue_id { json.type "integer" }
  json.github_url      { json.type "string" }
  json.lighthouse_url  { json.type "string" }
  json.name            { json.type "string" }
  json.title           { json.type "string" }
  json.repo            { json.partial! "schema/repo" }

  unless is_source_branch
    json.source_branch do
      json.partial! "schema/branch", is_source_branch: true
    end
  end
end