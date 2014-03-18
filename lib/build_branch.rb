class BuildBranch < Struct.new(:params, :user)

  attr_accessor :branch, :options, :repo, :source

  def build
    @options = get_options
    @branch  = find_branch
    
    @repo    = options[:repo]
    @source  = options[:source]
    reset    = options[:reset]

    reset_branch  if reset

    if branch.new_record?
      branch.user          = user         if user
      branch.repo          = find_repo    if repo
      branch.source_branch = pick_source  if source
    end

    branch
  end

  def build_with_external
    branch = update_branch
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
    find_branch
  end

  def update_branch
    UpdateBranch.new(build).update
  end
end