class PullRequest

  def update_branch(branch)
    github            = Github.new(branch.user)
    pull_request      = github.pull_request(branch)
    branch.github_url = pull_request[:issue_url]
    save
  end
end