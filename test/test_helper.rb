ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# # Modified slightly and borrowed from MiniTest README.
# #   See:     http://rdoc.info/github/seattlerb/minitest/master/file/README.txt
# #   Section: Customizable Test Runner Types
module MiniTestWithHooks
  class Unit <  MiniTest::Unit
    def before_suites; end   # run before all tests cases
    def before_suite; end    # run before all test suites
    def after_suites; end    # run after all test cases
    def after_suite; end     # run after all test suites

    def _run_suites(suites, type)
      begin
        before_suites
        super(suites, type)
      ensure
        after_suites
      end
    end

    def _run_suite(suite, type)
      begin
        suite.before_suite if suite.respond_to?(:before_suite)
        super(suite, type)
      ensure
        suite.after_suite if suite.respond_to?(:after_suite)
      end
    end
  end
end
MiniTest::Unit.runner = MiniTestWithHooks::Unit.new

module TestHelper
  extend self

  # December, 26, 1985 + a user-defined time
  def clinic_date(time=nil)
    date = "12/26/1985"

    if time
      m, d, y = date.split('/')
      Time.parse "#{[y, m, d] * '-'} #{time}"
    else
      Date.strptime(date, "%m/%d/%Y")
    end
  end

  def valid_patient
    Factory.build(:patient)
  end

  def create_test_patients(date=Date.today)
    (6..17).map { |i| date + i.hours }.each do |datetime|
      Factory(:patient, :created_at => datetime, :updated_at => datetime)
    end
  end

  def create_test_prescriptions
    Factory(:prescription,
            :name     => "Amoxicillin",
            :quantity => 21,
            :dosage   => "500mg",
            :cost     => 12.99,
            :strength => "1 YID x 7days")
  end

  def create_test_procedures
    Factory(:procedure,
            :description => "Comp. Oral Exam",
            :code        => 150,
            :cost        => 90)
    Factory(:procedure,
            :description => "Panoramic film",
            :code        => 330,
            :cost        => 125)
  end

  def create_test_xray(time, patient)
    Factory(:patient_flow,
            :area_id    => ::ClinicArea::XRAY,
            :patient    => patient,
            :created_at => time)
  end
end
