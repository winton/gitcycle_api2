class BuildBranch
  class FindRepo < Struct.new(:repo, :user)

    def find
      Repo.where(repo_conditions).first_or_initialize
    end

    def repo_conditions
      rpo = repo
      usr = user

      if rpo.include?("/")
        usr, rpo = rpo.split("/")
        usr    = User.where(login: usr).first_or_create
      end

      { name: rpo, user_id: usr.id }
    end
  end
end