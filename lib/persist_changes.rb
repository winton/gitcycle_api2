module PersistChanges

  def self.included(base)
    base.after_save :record_changes
  end

  def add_changes(attributes)
    record_changes
    @last_changed += attributes
  end

  def current_changed
    ActiveSupport::HashWithIndifferentAccess[
      changed.map { |attr| [ attr, __send__(attr) ] }
    ]
  end

  def record_changes
    @last_changed = changed  unless @last_changed
  end

  def reset_changes
    @previously_changed = {}
    @changed_attributes = {}
  end

  def update_all_changes
    unless current_changed.empty?
      self.class.where(id: id).update_all(current_changed)
    end
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
end