json.(@branch, :issue_url, :lighthouse_url, :name, :source, :title)
json.repo do
  json.(@branch.repo, :name, :login)
  json.owner do
    json.(@branch.repo.owner, :name, :login)
  end
  json.user do
    json.(@branch.repo.user, :name, :login)
  end
end