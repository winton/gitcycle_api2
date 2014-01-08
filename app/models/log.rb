class Log < ActiveRecord::Base

  attr_accessible :event, :body, :session_id, :ran_at

  belongs_to :user

  def self.create_from_params(params, user)
    params[:events].each do |p|
      log = Log.new(
        event:      p[:event],
        body:       p[:body],
        session_id: p[:session_id],
        ran_at:     p[:ran_at]
      )
      log.user_id = user.id
      log.save
    end
  end
end
