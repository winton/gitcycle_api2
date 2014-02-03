module Updater
  class <<self

    def included(base)
      updaters = read_updaters
      updaters.each do |updater|
        base.include "Updaters::#{updater.classify}".constantize
      end

      define_update_method(base, updaters)
    end

    def define_update_method(base, updaters)
      base.send(:define_method, :update_from_changes) do
        updaters.each do |type|
          method = "update_from_#{type}"
          send(method)  if send(method + "?")
        end
      end
    end

    def read_updaters
      Dir["#{Rails.root}/lib/updaters/*"].map do |path|
        require path
        File.basename(path, ".rb")
      end
    end
  end
end