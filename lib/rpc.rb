class Rpc < Struct.new(:params, :user)

  def branch
    @branch ||= build_branch
  end

  def branch_name
    branch.name
  end

  def build_branch
    BuildBranch.new(params, user).build_with_external
  end

  def source_branch_name
    branch.source_branch.name
  end

  def source_branch_repo_login
    branch.source_branch.repo.user.login
  end

  def source_branch_repo_name
    branch.source_branch.repo.name
  end

  def track
    {
      commands: [
        [
          "Git", :checkout_remote,
          source_branch_repo_login,
          source_branch_repo_name,
          source_branch_name,
          branch_name
        ]
      ]
    }
  end
end