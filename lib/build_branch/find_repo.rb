class BuildBranch
  class FindRepo < Struct.new(:repo, :user)

    def find
      Repo.where(repo_conditions).first_or_initialize
    end

    def find_user(login)
      User.where(login: login).first_or_create
    end

    def repo_conditions
      name = repo
      usr  = user

      if name.include?("/")
        login, name = name.split("/")
        usr         = find_user(login)
      end

      { name: name, user_id: usr.id }
    end
  end
end