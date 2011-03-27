require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @report_date = CLINIC_DATE
    @patients    = Patient.all(:conditions => ["Date(created_at) = ?", @report_date])
  end

  test "should report on the specified date and span" do
    report = Reports::ClinicSummary.new(@report_date, "All")
    
    assert_equal report.day,  @report_date
    assert_equal report.span, "All"
  end
  
  test "should be reporting all patients checked in" do
    report = Reports::ClinicSummary.new(@report_date, "All")

    assert_equal @patients.count, report.patient_count
  end
end
