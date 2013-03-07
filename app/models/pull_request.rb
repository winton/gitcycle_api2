class PullRequest < ActiveRecord::Base

  attr_accessible :number, :status, :ticket_id, :url, :user_id

  class <<self

    def update!(page=1, limit=100)
      api_pull_requests = Github::PullRequest.recently_updated
    end
  end
end
