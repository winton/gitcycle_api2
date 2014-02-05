id_optional            ||= false
is_source_branch       ||= false
name_optional          ||= false
optional               ||= false
req                    ||= false
res                    ||= false
source_branch          ||= false
source_branch_optional ||= false
title_optional         ||= false

if req
  name_optional = true
end

if %w(GET POST PUT).include?(req) || res
  source_branch = true
end

if %w(POST PUT).include?(req)
  name_optional = false
end

if %w(GET PUT POST).include?(req) || %w(GET PUT).include?(res)
  source_branch_optional = true
end

if req || %w(GET).include?(res) || is_source_branch
  title_optional = true
end

if %w(GET POST).include?(req) || res == "GET"
  id_optional = true
end

json.type "object"
json.additionalProperties false
json.optional(true)  if optional
json.properties do
  json.id              { json.type "integer"; json.optional id_optional}
  json.github_issue_id { json.type "integer"; json.optional true }
  json.github_url      { json.type "string";  json.optional true }
  json.lighthouse_url  { json.type "string";  json.optional true }
  json.name            { json.type "string";  json.optional name_optional }
  json.title           { json.type "string";  json.optional title_optional }
  json.repo            { json.partial! "schema/repo" }

  unless req
    json.user do
      json.optional is_source_branch
      json.partial! "schema/user"
    end
  end

  if source_branch
    json.source_branch do
      json.optional source_branch_optional
      if req
        json.partial! "schema/source_branch"
      else
        json.partial! "schema/branch", is_source_branch: true
      end
    end
  end
end