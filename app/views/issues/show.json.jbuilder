json.array! @branches do |branch|
  @branch = branch
  json.partial! "branch/show"
end