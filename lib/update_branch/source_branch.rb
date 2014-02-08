class UpdateBranch
  class SourceBranch < Struct.new(:branch)

    def update?
      @name = branch.name
      @repo = branch.repo
      @user = branch.user

      return  unless @name && @repo && @user
      repo.ref_exists?(@user, @repo.owner, @name)
    end

    def update
      return  unless update?

      name  = "#{@repo.owner.login}/#{@repo.name}/#{@name}"
      track = Track.new(name: name)
      
      track.update_branch
    end
  end
end