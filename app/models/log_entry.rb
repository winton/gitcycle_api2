class LogEntry < ActiveRecord::Base

  attr_accessible :event, :body, :backtrace, :ran_at

  belongs_to :log
  belongs_to :user

  before_save :update_backtrace
  before_save :update_ran_at

  def ran_at_time
    Time.at(read_attribute(:ran_at) / 1000).
      in_time_zone("Pacific Time (US & Canada)")
  end

  private

  def generate_backtrace
    begin; raise; rescue => e
      e.backtrace.join("\n")
    end
  end

  def update_backtrace
    self.backtrace ||= generate_backtrace

    if self.backtrace.length > 9_999
      self.backtrace = self.backtrace[0..9_999]
    end
  end

  def update_ran_at
    self.ran_at ||= (Time.now.to_f * 1000.0).to_i
  end
end
