class Log < ActiveRecord::Base

  attr_accessible :exit_code, :started_at, :finished_at

  belongs_to :user
  has_many   :log_entries

  class <<self

    def create_from_params(params, user)
      first = params[:events].first rescue {}
      last  = params[:events].last  rescue {}

      log = user.logs.create(
        exit_code:   last[:body],
        started_at:  first[:ran_at].to_i,
        finished_at: last[:ran_at].to_i
      )

      params[:events].each do |p|
        log.log_entries.create(
          event:     p[:event],
          body:      p[:body],
          backtrace: p[:backtrace],
          ran_at:    p[:ran_at].to_i
        )
      end

      log
    end
  end

  def started_at_time
    Time.at(read_attribute(:started_at) / 1000).in_time_zone("Pacific Time (US & Canada)")
  end

  def finished_at_time
    Time.at(read_attribute(:finished_at) / 1000).in_time_zone("Pacific Time (US & Canada)")
  end
end