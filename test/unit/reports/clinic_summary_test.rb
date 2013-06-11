require "test_helper"

class ClinicSummaryTest < ActiveSupport::TestCase
  def setup
    @report_date = TestHelper.clinic_date

    TestHelper.create_test_prescriptions
    TestHelper.create_test_procedures
    (0..1).each do |i|
      TestHelper.create_test_patients(TestHelper.clinic_date + i.days)
    end

    @patients    = Patient.all(:order => "created_at",
                     :conditions => ["created_at::Date = ?", @report_date])
  end

  def test_only_reports_on_the_specified_date_and_span
    report = Reports::ClinicSummary.new(@report_date, "All")

    assert_equal report.day,  @report_date
    assert_equal report.span, "All"
  end

  def test_checked_in_patients
    report = Reports::ClinicSummary.new(@report_date, "All")

    assert_equal @patients.count, report.patient_count
  end

  def test_only_reports_on_patients_for_the_selected_time_span
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

  def test_radiology_patients
    xray_time = TestHelper.clinic_date("8:30 AM")
    xray_count = 3
    @patients.first(xray_count).each do |patient|
      TestHelper.create_test_xray(xray_time, patient)
    end

    report = Reports::ClinicSummary.new(@report_date, xray_time)
    assert_equal xray_count, report.xrays.to_i

    report = Reports::ClinicSummary.new(@report_date, "8:00 AM")
    assert_equal 0, report.xrays.to_i
  end

  def test_procedures_for_the_specified_day_or_span
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

  def test_prescriptions_for_the_specified_day_or_span
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

  def test_procedures_per_hour
    Time.zone
    ["8:30AM", "8:45 AM", "9:15 AM"].each do |time|
      PatientProcedure.create(:patient => @patients.first,
                              :procedure => Procedure.first,
                              :created_at => TestHelper.clinic_date(time))
    end
    report = Reports::ClinicSummary.new(@report_date, "All")

    first_entry = report.procedures_per_hour[0]
    assert_equal Time.zone.parse('1985-12-26 08:00 AM'), first_entry.hour
    assert_equal 2, first_entry.total

    second_entry = report.procedures_per_hour[1]
    assert_equal Time.zone.parse('1985-12-26 09:00 AM'), second_entry.hour
    assert_equal 1, second_entry.total
  end

  def test_patients_per_treatment_area
    report = Reports::ClinicSummary.new(@report_date, "All")

    pedo = FactoryGirl.create(:treatment_area, name: "Pediatrics")

    5.times do
      FactoryGirl.create(:patient_flow,
        created_at: TestHelper.clinic_date("8:30 AM"),
        treatment_area_id: pedo.id,
        area_id: ClinicArea::CHECKOUT
      )
    end

    surgery = FactoryGirl.create(:treatment_area, name: "Survery")

    4.times do
      FactoryGirl.create(:patient_flow,
        created_at: TestHelper.clinic_date("8:30 AM"),
        treatment_area_id: surgery.id,
        area_id: ClinicArea::CHECKOUT
      )
    end

    # These do not fall within the parameters of the report
    #
    FactoryGirl.create(:patient_flow,
      created_at: TestHelper.clinic_date("8:30 AM"),
      treatment_area_id: surgery.id,
      area_id: ClinicArea::CHECKIN
    )

    FactoryGirl.create(:patient_flow,
      created_at: TestHelper.clinic_date("8:30 AM") + 5.days,
      treatment_area_id: surgery.id,
      area_id: ClinicArea::CHECKOUT
    )

    results = report.patients_per_treatment_area

    assert_equal "5", results.where(treatment_area_id: pedo.id).first.patient_count
    assert_equal "4", results.where(treatment_area_id: surgery.id).first.patient_count
  end

  def test_multivisit_patients
    report = Reports::ClinicSummary.new(@report_date, "All")
    5.times do
      FactoryGirl.create(:patient,
        previous_chart_number: rand(1000),
        created_at: TestHelper.clinic_date("8:30 AM")
      )
    end

    assert_equal 5, report.multivisit_patents.count
  end
end
