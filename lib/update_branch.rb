class UpdateBranch < Struct.new(:branch)

  UPDATERS = Dir["#{File.dirname(__FILE__)}/update_branch/*.rb"]

  class << self
    def updaters
      @updaters ||= []
    end
  end

  def update
    self.class.updaters.each do |klass|
      updater = klass.new(branch)
      updater.update  if updater.update?
    end
    
    branch
  end

  UPDATERS.each { |path| require path }
end