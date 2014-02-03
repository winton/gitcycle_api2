module Updaters
  module Lighthouse

    def update_from_lighthouse?
      lighthouse_ticket_id_changed?
    end
    
    def update_from_lighthouse
      return  unless user
      user.update_nil_lighthouse_user_namespaces(lighthouse_namespace)
      
      lh_user = user.lighthouse_users.find_by(namespace: lighthouse_namespace)
      return  unless lh_user

      ticket = ::Lighthouse.new(lh_user).ticket(lighthouse_project_id, lighthouse_ticket_id)
      self.title = ticket[:title]
      self.body  = ticket[:body]
    end
  end
end