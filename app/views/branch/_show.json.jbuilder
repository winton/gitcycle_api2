json.ignore_nil!

json.(branch, :github_issue_id, :github_url, :lighthouse_url, :name, :title)

if branch.repo
  json.repo { json.partial! "branch/repo", repo: branch.repo }
end

if branch.source_branch
  json.source_branch { json.partial! "branch/show", branch: branch.source_branch }
end

if branch.user
  json.user { json.(branch.user, :login) }
end