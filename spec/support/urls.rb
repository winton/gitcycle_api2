RSpec.configure do |c|
  
  def generate_github_url(id=123)
    "https://github.com/source_branch:repo:user:login/source_branch:repo:name/pull/#{id}"
  end

  def generate_lighthouse_url
    "https://namespace.lighthouseapp.com/projects/0/tickets/0"
  end
end