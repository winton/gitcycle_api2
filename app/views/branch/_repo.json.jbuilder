json.(repo, :name)
json.user do
  json.(repo.user, :login)
end