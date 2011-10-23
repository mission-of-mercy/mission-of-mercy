require "test_helper"

class ClinicSummaryTest < MiniTest::Unit::TestCase
  def self.before_suite
    TestHelper.create_test_prescriptions
    TestHelper.create_test_procedures
    (0..1).each do |i| 
      TestHelper.create_test_patients(TestHelper.clinic_date + i.days)
    end
  end

  def setup
    @report_date = TestHelper.clinic_date
    @patients    = Patient.all(:order => "created_at",
                     :conditions => ["created_at::Date = ?", @report_date])
  end

  def test_should_report_on_the_specified_date_and_span
    report = Reports::ClinicSummary.new(@report_date, "All")
    
    assert_equal report.day,  @report_date
    assert_equal report.span, "All"
  end
  
  def test_should_be_reporting_all_patients_checked_in
    report = Reports::ClinicSummary.new(@report_date, "All")

    assert_equal @patients.count, report.patient_count
  end
  
  def test_should_report_on_patients_for_the_selected_time_span_only
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

  def test_should_report_on_radiology_numbers
    xray_time = TestHelper.clinic_date("8:30 AM")
    xray_count = 3
    @patients.first(xray_count).each do |patient|
      TestHelper.create_test_xray(xray_time, patient)
    end

    report = Reports::ClinicSummary.new(@report_date, xray_time)
    assert_equal xray_count, report.xrays
    
    report = Reports::ClinicSummary.new(@report_date, "8:00 AM")
    assert_equal 0, report.xrays
  end

  def test_should_only_report_on_procedures_for_the_specified_day_or_span
    @first_proc  = Procedure.first
    @second_proc = Procedure.all.second || Procedure.first

    PatientProcedure.create(:patient => @patients.first,
                            :procedure => @first_proc,
                            :created_at => TestHelper.clinic_date("8:30 AM"))
    PatientProcedure.create(:patient => @patients.first,
                            :procedure => @second_proc,
                            :created_at => TestHelper.clinic_date("9:30 AM"))

    report = Reports::ClinicSummary.new(@report_date, "8:30 AM")
    assert_equal 1,  report.procedure_count
    assert_equal @first_proc.cost, report.procedure_value
    
    report = Reports::ClinicSummary.new(@report_date, "8:00 AM")
    assert_equal 0, report.procedure_count
    assert_equal 0, report.procedure_value
    
    report = Reports::ClinicSummary.new(@report_date, "All")
    assert_equal 2,   report.procedure_count
    assert_equal @first_proc.cost + @second_proc.cost, report.procedure_value
  end
  
  def test_should_only_report_on_prescriptions_for_the_specified_day_or_span
    @prescription = Prescription.first
    ["8:30 AM", "9:30 AM"].each do |time|
      PatientPrescription.create(:patient => @patients.first,
                                 :prescription => @prescription,
                                 :prescribed => true,
                                 :created_at => TestHelper.clinic_date(time))
    end

    report = Reports::ClinicSummary.new(@report_date, "8:30 AM")
    assert_equal 1, report.prescription_count
    assert_equal @prescription.cost, report.prescription_value
    
    report = Reports::ClinicSummary.new(@report_date, "8:00 AM")
    assert_equal 0, report.prescription_count
    assert_equal 0, report.prescription_value
    
    report = Reports::ClinicSummary.new(@report_date, "All")
    assert_equal 2, report.prescription_count
    assert_equal @prescription.cost * 2.0, report.prescription_value
  end
end
