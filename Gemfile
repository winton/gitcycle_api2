source 'http://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'less'
  gem 'therubyracer', platforms: :ruby
  gem 'twitter-bootstrap-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'haml-rails'
gem 'jquery-rails'
gem 'less-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn-rails'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'addressable'
gem 'excon'
gem 'faraday'
gem 'faraday_middleware'
gem 'omniauth'
gem 'omniauth-github'
gem 'sidekiq', github: "mperham/sidekiq"
gem 'sinatra'
gem 'slim'
gem 'whenever', require: false

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "vcr"
end