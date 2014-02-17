class UpdateBranch < Struct.new(:user)

  UPDATERS = Dir["#{File.dirname(__FILE__)}/update_branch/*.rb"]

  class << self
    def updaters
      @updaters ||= []
    end
  end

  def from_track_params(track_params)
    branch = track_params.find_branch

    self.class.updaters.each do |klass|
      updater = klass.new(branch)
      updater.update  if updater.update?
    end
    
    branch.user = user  if user
    branch
  end

  UPDATERS.each { |path| require path }
end