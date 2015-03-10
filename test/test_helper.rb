ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'

require 'capybara-screenshot/minitest'
require 'database_cleaner'
require 'minitest/mock'

require_relative 'support/integration'
require_relative 'support/helpers'
require_relative 'support/minitest_capybara'
require_relative 'support/redis_stub'
require_relative '../db/seeds/users'

Capybara.javascript_driver = :webkit

class Capybara::Rails::TestCase
  include Support::Integration

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    Seeds.create_users(:password => "temp123", :xray_stations => 5)
    FactoryGirl.create(:treatment, :name => 'Cleaning')
    FactoryGirl.create(:race, :category => 'Caucasian/White')
  end

  after do
    DatabaseCleaner.clean
  end
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
end

# Stub redis
#
$redis = RedisStub.new
