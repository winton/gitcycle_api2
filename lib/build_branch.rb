class BuildBranch < Struct.new(:params, :user)

  attr_accessor :branch, :options, :repo, :source

  def build
    self.options = get_options
    self.branch  = find_branch
    
    self.repo    = options[:repo]
    self.source  = options[:source]
    reset        = options[:reset]

    reset_branch  if reset

    branch.user          = user         if user
    branch.repo          = find_repo    if repo
    branch.source_branch = pick_source  if source

    branch
  end

  def build_with_external
    branch = UpdateBranch.new(build).update
    branch.save
    branch
  end

  def find_branch
    FindBranch.new(options).find
  end

  def find_repo
    FindRepo.new(repo, user).find
  end

  def get_options
    Options.new(params).options
  end

  def pick_source
    PickSource.new(branch, source).pick
  end

  def reset_branch
    return unless branch.id
    branch.destroy
    FindBranch.new(options).find
  end
end