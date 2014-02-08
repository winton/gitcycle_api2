class ApplicationController < ActionController::Base

  protect_from_forgery

  private

  def authenticate_by_token
    authenticate_or_request_with_http_token do |token, options|
      @user = User.where(gitcycle: token).first
    end
  end

  def authenticate_by_session
    @user = session[:user]
    redirect_to '/' unless @user
  end

  def log_string_with_request(type, str)
    @user.log_entries.create(
      event: "#{request.request_method}_#{type}".downcase,
      body:  "#{request.fullpath}\n\n#{str}"
    )
  end

  def existing_branch_only
    render(nothing: true, status: :forbidden)  if @branch.new_record?
  end

  def find_branch
    @branch = Track.new(params).find_branch
    render(nothing: true, status: :forbidden)  unless @branch
  end

  def log_request
    log_string_with_request(:req, params.inspect)
    yield
    log_string_with_request(:res, response.body)
  rescue Exception => e
    log_string_with_request(:error, "#{e.to_s}\n#{e.backtrace.join("\n")}")
    raise e
  end
end
