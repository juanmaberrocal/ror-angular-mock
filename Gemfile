source 'http://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use mysql2 as the database for Active Record
gem 'mysql2'
# Use Devise token authentication
gem 'devise_token_auth'
# Use Responders for controller API respond_with
gem 'responders'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use Bootstrap
# gem 'bootstrap-sass' # now handled by Bower
# Use CSRF tokens for AngularJS $http
gem 'angular_rails_csrf'
# Use AngularJS templates from assets
gem 'angular-rails-templates'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# handle assets through bower
gem 'bower-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Testing
  # backend
  gem 'devise'
  gem 'rspec-rails' #, '2.14.1' # due to windows error on rspec:install
  gem 'factory_girl_rails'
  # frontend
  gem 'jasmine-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
