require "test_helper"

class UserTest < Test::Unit::TestCase
  setup do
    @report_date = Date.today
    @report_span = "All"
  end

  test "should report on the specified date and span" do
    report = Reports::ClinicSummary.new(@report_date, @report_span)
    
    assert_equal report.day,  @report_date
    assert_equal report.span, @report_span
  end
end
