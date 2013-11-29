json.(@repo, :name)

json.owner do
  json.(@repo.owner, :name, :login)
end if @repo.owner

json.user do
  json.(@repo.user, :name, :login)
end