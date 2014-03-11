class Rpc < Struct.new(:params, :user)

  def build_branch
    BuildBranch.new(params, user).build_with_external
  end

  def track
    {
      branch:   build_branch,
      commands: [ :checkout_from_remote ]
    }
  end
end