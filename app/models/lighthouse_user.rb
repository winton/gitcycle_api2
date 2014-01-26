require 'persist_changes'

class LighthouseUser < ActiveRecord::Base

  include PersistChanges

  attr_accessible :namespace, :token

  after_commit :update_lighthouse_id
  after_save   :update_lighthouse_id if Rails.env == 'test'

  after_commit :remove_dups
  after_save   :remove_dups if Rails.env == 'test'

  belongs_to :user

  def remove_dups
    LighthouseUser.where(<<-SQL, namespace, token, id).delete_all
      namespace = ? AND token = ? AND id <> ?
    SQL
  end

  def update_lighthouse_id
    return if lighthouse_id || !namespace
    reset_changes # makes test env same as production

    self.lighthouse_id = Lighthouse.new(self).user[:id]
    update_all_changes
  end
end
