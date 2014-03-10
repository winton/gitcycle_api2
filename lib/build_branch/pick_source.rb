class BuildBranch
  class PickSource < Struct.new(:branch, :source)

    def github_ref_exists?(branch, ref_user)
      Github.new(branch.repo, branch.user).
        reference(ref_user, branch)[:ref]
    end

    def owner_branch_exists?(branch)
      owner  = branch.repo.owner
      owner  if github_ref_exists?(user, branch, owner)
    end

    def pick
      src, repo = source_from_string_with_slashes
      src, repo = source_from_owner   unless src && repo
      src, repo = source_from_string  unless src && repo

      BuildBranch.new(branch: src, repo: repo).build_branch
    end

    def source_from_owner
      return unless owner = owner_branch_exists?(branch)
      [ source, "#{owner.login}/#{branch.repo.name}" ]
    end

    def source_from_string
      [ source, branch.repo.name ]
    end

    def source_from_string_with_slashes
      return unless source.include?("/")

      pieces = src.split("/")
      src    = pieces.pop
      repo   = pieces.join("/")

      [ src, repo ]
    end
  end
end