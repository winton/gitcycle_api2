json.ignore_nil!

json.(@branch, :created, :github_issue_id, :github_url, :lighthouse_url, :name, :source, :title)

json.repo { json.partial! "branch/repo", repo: @branch.repo }

if @branch.source_repo
  json.source_repo { json.partial! "branch/repo", repo: @branch.source_repo }
end