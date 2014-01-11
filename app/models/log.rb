class Log < ActiveRecord::Base

  attr_accessible :exit_code, :started_at, :finished_at

  belongs_to :user
  has_many   :log_entries

  class <<self

    def create_from_params(params, user)
      params[:events].each { |e| e[:ran_at] = e[:ran_at].to_i }

      first = params[:events].first
      last  = params[:events].last

      log = user.logs.create(
        exit_code:   last[:body],
        started_at:  first[:ran_at],
        finished_at: last[:ran_at]
      )

      absorb_server_side_log_entries(user, log, first, last)
      create_log_entries(user, log, params)
      log
    end

    def absorb_server_side_log_entries(user, log, first, last)
      user.log_entries.where(log_id: nil).each do |entry|
        if entry.ran_at >= first[:ran_at] && entry.ran_at <= last[:ran_at]
          entry.log = log
          entry.save
        else
          entry.destroy
        end
      end
    end

    def create_log_entries(user, log, params)
      params[:events].each do |p|
        entry = log.log_entries.build(
          event:     p[:event],
          body:      p[:body],
          backtrace: p[:backtrace],
          ran_at:    p[:ran_at].to_i
        )
        entry.user = user
        entry.save
      end
    end
  end

  def started_at_time
    Time.at(read_attribute(:started_at) / 1000).
      in_time_zone("Pacific Time (US & Canada)")
  end

  def finished_at_time
    Time.at(read_attribute(:finished_at) / 1000).
      in_time_zone("Pacific Time (US & Canada)")
  end
end