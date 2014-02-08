class UpdateBranch
  class FromGithub < Struct.new(:branch)

    def update?
      branch.user && branch.github_issue_id_changed?
    end

    def update
      return  unless update?

      github       = Github.new(branch.user)
      issue        = github.issue(branch.github_url)
      branch.title = issue[:title]
    end
  end
end