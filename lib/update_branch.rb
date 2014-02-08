class UpdateBranch < Struct.new(:user)

  def from_track_params(track_params)
    branch = track_params.find_branch
    
    FromGithub.new(branch).update
    FromLighthouse.new(branch).update
    FromName.new(branch).update
    SourceBranch.new(branch).update
    
    branch.user = user  if user
    branch
  end
end