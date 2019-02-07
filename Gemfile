source 'http://rubygems.org'

ruby "2.6.0"

# gem 'protected_attributes'

# bundle install after modifying this
gem 'rails', '6.0.0.beta1'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'friendly_id'
gem 'haml-rails', git: 'https://github.com/indirect/haml-rails'
# gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'thumbs_up'
gem 'turbolinks', '~> 5'
gem 'uglifier'
gem 'webpacker', '>= 4.0.0.rc.3'

gem 'hpricot', '0.8.6'
# gem 'flutie'

group :development, :test do
  gem 'bundler-audit', require: false
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'rspec-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'better_errors'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'factory_girl_rails', require: false
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
