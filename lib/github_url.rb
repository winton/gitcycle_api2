class GithubUrl < Struct.new(:url)

  def issue_id
    url.match(/\/(pull|issues)\/(\d+)/).to_a[2]
  end

  def to_conditions
    { github_issue_id: issue_id }
  end
end