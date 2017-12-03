source 'https://rubygems.org'
ruby '2.1.2'

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
  gem 'launchy'
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'vcr', '2.9.3'
end

group :production do
  gem 'rails_12factor'
end