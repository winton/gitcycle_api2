module Updater

  def self.included(base)
    updaters = Dir["#{Rails.root}/lib/updaters/*"].map do |path|
      require path
      type = File.basename(path, ".rb")
      base.include "Updaters::#{type.classify}".constantize
      type
    end

    base.send(:define_method, :update_from_changes) do
      updaters.each do |type|
        method = "update_from_#{type}"
        send(method)  if send(method + "?")
      end
    end
  end
end