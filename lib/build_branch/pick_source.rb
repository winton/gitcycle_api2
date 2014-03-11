class BuildBranch
  class PickSource < Struct.new(:branch, :source)

    attr_accessor :repo

    def build_branch
      BuildBranch.new(branch: source, repo: repo).build
    end

    def github
      Github.new(branch.repo, branch.user)
    end

    def github_ref_exists?(user)
      github.reference(user, source)[:ref]
    end

    def owner_branch_exists?
      owner  = branch.repo.owner
      owner  if github_ref_exists?(owner)
    end

    def pick
      source_from_string_with_slashes
      source_from_owner   unless repo
      source_from_string  unless repo

      build_branch
    end

    def source_from_owner
      return unless owner = owner_branch_exists?
      self.repo = "#{owner.login}/#{branch.repo.name}"
    end

    def source_from_string
      self.repo = branch.repo.name
    end

    def source_from_string_with_slashes
      return unless source.include?("/")

      pieces      = src.split("/")
      self.source = pieces.pop
      self.repo   = pieces.join("/")
    end
  end
end