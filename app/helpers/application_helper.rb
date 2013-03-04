module ApplicationHelper

  def active?(path)
    'active' if request.path == path
  end
end
