module Updaters
  module Github

    def update_from_github?
      github_issue_id_changed?
    end

    def update_from_github
      return  unless user

      issue      = ::Github.new(user).issue(github_url)
      self.title = issue[:title]
    end
  end
end