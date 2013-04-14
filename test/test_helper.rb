ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/spec'
require 'rails/test_help'
require 'capybara/rails'
require 'database_cleaner'
require_relative 'support/integration'
require_relative 'support/helpers'
require 'capybara-screenshot/minitest'
require_relative '../db/seeds/users'

Turn.config.natural = true

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Support::Integration

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.strategy = :truncation
    Seeds.create_users(:password => "temp123", :xray_stations => 5)
    FactoryGirl.create(:treatment, :name => 'Cleaning')
    FactoryGirl.create(:race, :category => 'Caucasian/White')
  end

  teardown do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

class MiniTest::Spec
  DatabaseCleaner.strategy = :transaction

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
