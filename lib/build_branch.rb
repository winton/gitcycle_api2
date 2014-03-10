class BuildBranch < Struct.new(:params, :user)

  def build
    options = Options.new(params).options
    branch  = FindBranch.new(options).find

    repo   = options[:repo]
    reset  = options[:reset]
    source = options[:source]

    reset_branch(branch, options)  if reset

    branch.user          = user                                 if user
    branch.repo          = FindRepo.new(repo, user).find        if repo
    branch.source_branch = PickSource.new(branch, source).pick  if source

    branch
  end

  def build_with_external
    branch = UpdateBranch.new(build).update
    branch.save
    branch
  end

  def reset_branch(branch, options)
    return unless branch.id
    branch.destroy
    FindBranch.new(options).find
  end
end