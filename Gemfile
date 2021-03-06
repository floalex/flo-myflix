source 'https://rubygems.org'

# bundle command to install the gems
gem 'bcrypt'
gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'fabrication'
gem 'faker'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'sidekiq', '4.2.10'
gem 'carrierwave'   # for uploading
gem 'mini_magick'   # for image processing
gem 'figaro'
gem 'stripe'
gem 'stripe_event'
gem 'draper'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# jbuilder for api
gem 'jbuilder'

group :development do
  gem 'thin'
  gem "better_errors", '2.2.0'  # to prevent bundle install error
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'capybara'
  gem 'capybara-email', '2.4.0'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'poltergeist'
end

group :staging, :production do
  gem 'rails_12factor'
end