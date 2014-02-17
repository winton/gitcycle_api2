class UpdateBranch
  class SourceBranch < Struct.new(:branch)

    def update?
      name, repo, user = branch_values
      return  unless repo

      repo.ref_exists?(user, repo.owner, name)
    end

    def update
      name, repo, user = branch_values
      return  unless name && repo && user

      name  = "#{repo.owner.login}/#{repo.name}/#{name}"
      track = Track.new(name: name)
      
      track.update_branch
    end

    private

    def branch_values
      [ branch.name, branch.repo, branch.user ]
    end

    def ref_exists?(user, ref_user, branch)
      return  unless user && ref_user && branch
      ref = Github.new(self, user).reference(ref_user, branch)
      ref[:ref].present?
    end
  end

  updaters << SourceBranch
end