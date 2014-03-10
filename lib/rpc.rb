class Rpc < Struct.new(:params, :user)

  def track
    {
      branch:   BuildBranch.new(params, user).build_with_external,
      commands: [ :checkout_from_remote ]
    }
  end
end