json.type "object"
json.additionalProperties false
json.optional(true)  if defined?(optional) && optional
json.properties do
  json.github_issue_id { json.type "integer"; json.optional true }
  json.github_url      { json.type "string";  json.optional true }
  json.lighthouse_url  { json.type "string";  json.optional true }
  json.name            { json.type "string" }
  json.title           { json.type "string" }
  json.repo            { json.partial! "schema/repo" }
  json.user            { json.partial! "schema/user" }

  if defined?(source_branch) && source_branch
    json.source_branch { json.partial! "schema/branch", optional: true }
  end
end