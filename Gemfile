source 'https://rubygems.org'

gem 'rails', '~> 4.1.9'
gem 'json',  '~> 1.7.7'
gem 'pg'
gem 'haml'
gem 'sass'
gem 'dotenv-rails'
gem 'nokogiri'
gem 'will_paginate', '>= 3.0.5'
gem 'devise'
gem 'dynamic_form'
gem 'draper'
gem 'rack-pjax'
gem 'virtus'
gem 'axlsx'
gem 'axlsx_rails'
gem 'prawn', '~> 0.15.0'

gem 'resque'
gem 'resque-web', require: 'resque_web'

gem 'jquery-rails'
gem 'will_paginate-bootstrap'

gem 'rails_setup'
gem 'faker',            :require => false
gem 'rubyzip', '0.9.9', :require => false

gem 'coffee-rails', '~> 4.0.0'
gem 'sass-rails',   '~> 4.0.0'
gem 'uglifier'
gem 'compass-rails'
gem 'bootstrap-sass-rails', '~> 2.3.2.1'
gem 'font-awesome-rails'

# MOMMA Gems

gem 'print_chart', '~> 0.0.2', 
  git: 'https://github.com/mission-of-mercy/print_chart.git'
gem 'support_notification',
  git: 'https://github.com/mission-of-mercy/support_notification.git'

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
end

group :development do
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano_colors'
end

group :test do
  gem 'minitest-spec-rails', '~> 5.2.0'
  gem 'capybara_minitest_spec'
  gem 'minitest-metadata'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'resque_unit'
end

group :production do
  gem 'unicorn-rails'
end
