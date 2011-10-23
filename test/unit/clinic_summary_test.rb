require "test_helper"

class ClinicSummaryTest < ActiveSupport::TestCase
  setup do
    @report_date = TestHelper.clinic_date

    create_test_prescriptions
    create_test_procedures
    (0..1).each { |i| create_test_patients(@report_date + i.days) }

    @patients    = Patient.all(:order => "created_at",
                     :conditions => ["created_at::Date = ?", @report_date])
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
  
  test "should report on patients for the selected time span only" do    
    Reports::ClinicSummary::TIME_SPANS.each_with_index do |span, index|
      if index == 0 # All
        expected_patient_count = @patients.count 
      else
        expected_patient_count = index
      end
      
      report = Reports::ClinicSummary.new(@report_date, span)
      assert_equal expected_patient_count, report.patient_count, 
                   "#{span} should have #{expected_patient_count} patients"
    end
  end

  test "should report on radiology numbers" do
    xray_time = TestHelper.clinic_date("8:30 AM")
    xray_count = 3
    @patients.first(xray_count).each { |p| create_test_xray(xray_time, p) }

    report = Reports::ClinicSummary.new(@report_date, xray_time)
    assert_equal xray_count, report.xrays
    
    report = Reports::ClinicSummary.new(@report_date, "8:00 AM")
    assert_equal 0, report.xrays
  end

  test "should only report on procedures for the specified day / span" do
    @procedures = Procedure.all
    PatientProcedure.create(:patient => @patients.first,
                            :procedure => @oral_exam,
                            :created_at => TestHelper.clinic_date("8:30 AM"))
    PatientProcedure.create(:patient => @patients.first,
                            :procedure => @pan_film,
                            :created_at => TestHelper.clinic_date("9:30 AM"))

    report = Reports::ClinicSummary.new(@report_date, "8:30 AM")
    assert_equal 1,  report.procedure_count
    assert_equal 90, report.procedure_value
    
    report = Reports::ClinicSummary.new(@report_date, "8:00 AM")
    assert_equal 0, report.procedure_count
    assert_equal 0, report.procedure_value
    
    report = Reports::ClinicSummary.new(@report_date, "All")
    assert_equal 2,   report.procedure_count
    assert_equal 215, report.procedure_value
  end
  
  test "should only report on prescriptions for the specified day / span" do
    ["8:30 AM", "9:30 AM"].each do |time|
      PatientPrescription.create(:patient => @patients.first,
                                 :prescription => @amoxicillin,
                                 :prescribed => true,
                                 :created_at => TestHelper.clinic_date(time))
    end

    report = Reports::ClinicSummary.new(@report_date, "8:30 AM")
    assert_equal 1, report.prescription_count
    assert_equal @amoxicillin.cost, report.prescription_value
    
    report = Reports::ClinicSummary.new(@report_date, "8:00 AM")
    assert_equal 0, report.prescription_count
    assert_equal 0, report.prescription_value
    
    report = Reports::ClinicSummary.new(@report_date, "All")
    assert_equal 2, report.prescription_count
    assert_equal @amoxicillin.cost * 2.0, report.prescription_value
  end
end
