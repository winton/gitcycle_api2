class UpdateBranch
  class FromLighthouse < Struct.new(:branch)

    def update?
      branch.lighthouse_ticket_id_changed?
    end
    
    def update
      return  unless branch.user

      branch.user.
        update_nil_lighthouse_user_namespaces(lighthouse_namespace)
      
      return unless lh_user = branch.user.lighthouse_users.find_by(
        namespace: lighthouse_namespace
      )

      ticket = ::Lighthouse.new(lh_user).ticket(
        lighthouse_project_id, lighthouse_ticket_id
      )

      branch.title = ticket[:title]
      branch.body  = ticket[:body]
    end
  end

  updaters << FromLighthouse
end