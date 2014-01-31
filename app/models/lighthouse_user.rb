class LighthouseUser < ActiveRecord::Base

  attr_accessible :namespace, :token

  after_commit :remove_dups
  after_save   :remove_dups if Rails.env == 'test'

  belongs_to :user

  class <<self
    def find_from_params(params, user)
      lh_user = user.lighthouse_users.where(
        namespace: nil,
        token:     params[:token]
      ).first_or_initialize

      lh_user.update_lighthouse_id
      lh_user
    end
  end

  def remove_dups
    LighthouseUser.where(<<-SQL, namespace, token, id).delete_all
      namespace = ? AND token = ? AND id <> ?
    SQL
  end

  def update_lighthouse_id
    if !lighthouse_id && namespace
      self.lighthouse_id = Lighthouse.new(self).user[:id]
    end
    save
  end
end
