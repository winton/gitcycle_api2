module PersistChanges

  def self.included(base)
    base.after_save :record_changes
  end

  def add_changes(attributes)
    record_changes
    @last_changed += attributes
  end

  def was_changed?(attribute, log=false)
    record_changes
    attribute = attribute.to_s
    match     = @last_changed.include?(attribute)
    match   ||= changed.include?(attribute)

    if log
      puts "attribute:     #{attribute.inspect}"
      puts "@last_changed: #{@last_changed.inspect}"
      puts "changed:       #{changed.inspect}"
      puts "match:         #{match.inspect}"
    end
    
    match
  end

  def record_changes
    @last_changed = changed  unless @last_changed
  end
end