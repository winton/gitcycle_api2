class LogEntry < ActiveRecord::Base

  attr_accessible :event, :body, :backtrace, :ran_at

  belongs_to :log
end
