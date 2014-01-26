json.array! @branches do |branch|
  json.partial! "branch/show", branch: branch
end