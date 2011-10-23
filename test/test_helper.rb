ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "factory_girl"
require "minitest/autorun"


module MiniTestWithHooks
  class Unit <  MiniTest::Unit
    def before_suites; end
    def before_suite; end
    def after_suites; end
    def after_suite; end

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
  extend self;
  
  # December, 26, 1985 + a user-defined time
  def clinic_date(time=nil)
    date = "12/26/1985"
    
    if time
      Time.parse([date, time].join(' '))
    else
      Date.strptime(date, "%m/%d/%Y")
    end    
  end
  
  def valid_patient
    Factory.build(:patient)
  end
end

class MiniTest::Unit::TestCase

  def create_test_patients(date=Date.today)
    (6..17).map { |i| date + i.hours }.each do |datetime|
      Factory(:patient, :created_at => datetime, :updated_at => datetime)
    end
  end

  def create_test_prescriptions
    @amoxicillin = Factory(:prescription,
                           :name     => "Amoxicillin",
                           :quantity => 21,
                           :dosage   => "500mg",
                           :cost     => 12.99,
                           :strength => "1 YID x 7days")
  end

  def create_test_procedures
    @oral_exam = Factory(:procedure,
                         :description => "Comp. Oral Exam",
                         :code        => 150,
                         :cost        => 90)
    @pan_film  = Factory(:procedure,
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
