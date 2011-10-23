ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module TestHelper
  extend self
  
  # December, 26, 1985
  def clinic_date(time=nil)
    date = "12/26/1985"
    
    if time
      Time.parse([date, time].join(' '))
    else
      Date.strptime(date, "%m/%d/%Y")
    end    
  end
  
  def valid_patient
    Patient.new(
      :first_name         => "Jordan",
      :last_name          => "Byron",
      :date_of_birth      => Date.civil(1985, 12, 26),
      :sex                => "M",
      :race               => "AMERICAN",
      :chief_complaint    => "Too Amazing",
      :last_dental_visit  => "Today",
      :travel_time        => 1,  
      :city               => "Naugatuck", 
      :state              => "CT")
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
