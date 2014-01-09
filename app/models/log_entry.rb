class LogEntry < ActiveRecord::Base

  attr_accessible :event, :body, :backtrace, :ran_at

  belongs_to :log

  def ran_at_time
    Time.at(read_attribute(:ran_at) / 1000).in_time_zone("Pacific Time (US & Canada)")
  end
end
