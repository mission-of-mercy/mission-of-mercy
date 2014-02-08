require_relative '../../test_helper'

describe Reports::ClinicSummary do
  let(:report_date) { TestHelper.clinic_date }
  let(:patients)    { Patient.where("created_at::Date = ?", report_date).
                      order("created_at") }

  let(:report)      { Reports::ClinicSummary.new(report_date, "All") }

  before do
    TestHelper.create_test_prescriptions
    TestHelper.create_test_procedures
    (0..1).each do |i|
      TestHelper.create_test_patients(report_date + i.days)
    end
    patients # Create patients
  end

  it "only reports on the specified date and span" do
    report = Reports::ClinicSummary.new(report_date, "All")

    report.day.must_equal  report_date
    report.span.must_equal "All"
  end

  it "reports all checked in patients" do
    report = Reports::ClinicSummary.new(report_date, "All")

    report.patient_count.must_equal patients.count
  end

  it "only reports on patients for the selected time span" do
    Reports::ClinicSummary::TIME_SPANS.each_with_index do |span, index|
      if index == 0 # All
        expected_patient_count = patients.count
      else
        expected_patient_count = index
      end

      report = Reports::ClinicSummary.new(report_date, span)
      report.patient_count.must_equal expected_patient_count
    end
  end

  it "reports all patients who have visited radiology" do
    xray_time = TestHelper.clinic_date("8:30 AM")
    xray_count = 3

    patients.first(xray_count).each do |patient|
      TestHelper.create_test_xray(xray_time, patient)
    end

    report = Reports::ClinicSummary.new(report_date, xray_time)
    report.xrays.to_i.must_equal xray_count

    report = Reports::ClinicSummary.new(report_date, "8:00 AM")
    report.xrays.to_i.must_equal 0
  end

  it "reports all procedures for the specified day or span" do
    first_proc  = Procedure.first
    second_proc = Procedure.all.second || Procedure.first

    PatientProcedure.create(:patient    => patients.first,
                            :procedure  => first_proc,
                            :created_at => TestHelper.clinic_date("8:30 AM"))
    PatientProcedure.create(:patient    => patients.first,
                            :procedure  => second_proc,
                            :created_at => TestHelper.clinic_date("9:30 AM"))

    report = Reports::ClinicSummary.new(report_date, "8:30 AM")
    report.procedure_count.must_equal 1
    report.procedure_value.must_equal first_proc.cost

    report = Reports::ClinicSummary.new(report_date, "8:00 AM")
    report.procedure_count.must_equal 0
    report.procedure_value.must_equal 0

    report = Reports::ClinicSummary.new(report_date, "All")
    report.procedure_count.must_equal 2
    report.procedure_value.must_equal first_proc.cost + second_proc.cost
  end

  it "reports prescriptions for the specified day or span" do
    prescription = Prescription.first
    ["8:30 AM", "9:30 AM"].each do |time|
      PatientPrescription.create(:patient => patients.first,
                                 :prescription => prescription,
                                 :prescribed => true,
                                 :created_at => TestHelper.clinic_date(time))
    end

    report = Reports::ClinicSummary.new(report_date, "8:30 AM")
    report.prescription_count.must_equal 1
    report.prescription_value.must_equal prescription.cost

    report = Reports::ClinicSummary.new(report_date, "8:00 AM")
    report.prescription_count.must_equal 0
    report.prescription_value.must_equal 0

    report = Reports::ClinicSummary.new(report_date, "All")
    report.prescription_count.must_equal 2
    report.prescription_value.must_equal prescription.cost * 2.0
  end

  it "reports procedures per hour" do
    Time.zone
    ["8:30AM", "8:45 AM", "9:15 AM"].each do |time|
      PatientProcedure.create(:patient => patients.first,
                              :procedure => Procedure.first,
                              :created_at => TestHelper.clinic_date(time))
    end

    first_entry = report.procedures_per_hour[0]
    first_entry.hour.must_equal Time.zone.parse('1985-12-26 08:00 AM')
    first_entry.total.must_equal 2

    second_entry = report.procedures_per_hour[1]
    second_entry.hour.must_equal Time.zone.parse('1985-12-26 09:00 AM')
    second_entry.total.must_equal 1
  end

  it "reports patients per treatment area" do
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

    results.where(treatment_area_id: pedo.id)[0].patient_count.must_equal 5
    results.where(treatment_area_id: surgery.id)[0].patient_count.must_equal 4
  end

  it "reports how many patients have gone through the clinic multiple times" do
    report = Reports::ClinicSummary.new(report_date, "All")
    5.times do
      FactoryGirl.create(:patient,
        previous_chart_number: rand(1000),
        created_at: TestHelper.clinic_date("8:30 AM"))
    end

    report.multivisit_patents.count.must_equal 5
  end

  it "calculates the average time a patient is in the clinic" do
    patients.each do |patient|
      FactoryGirl.create(:patient_check_in,
                         :patient    => patient,
                         :created_at => TestHelper.clinic_date("6:30 AM"))
      FactoryGirl.create(:patient_check_out,
                         :patient    => patient,
                         :created_at => TestHelper.clinic_date("2:30 PM"))
    end

    report.average_patient_treatment_time.must_equal "08:00:00"
  end
end
