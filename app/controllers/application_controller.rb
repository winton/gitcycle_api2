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

  def log_string_with_request(str)
    @user.log_entries.create(
      event: "#{request.request_method}_req".downcase,
      body:  "#{request.fullpath}\n\n#{str}"
    )
  end

  def existing_branch_only
    render(nothing: true, status: :forbidden)  if @branch.new_record?
  end

  def find_branch
    params[:user_id] = @user.id
    @branch = Branch.find_from_params(params)
    
    render(nothing: true, status: :forbidden)  unless @branch
  end

  def find_repo
    @repo = Repo.find_from_params(params)
    render(nothing: true, status: :forbidden)  unless @repo
  end

  def log_request
    log_string_with_request(params.inspect)
    yield
    log_string_with_request(response.body)
  end
end
