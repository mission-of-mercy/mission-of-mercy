require 'test_helper'

class CheckOutTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit

    @patient        = FactoryGirl.create(:patient)
    @treatment_area = FactoryGirl.create(:treatment_area)

    5.times do
      FactoryGirl.create(:procedure_treatment_area_mapping, :treatment_area => @treatment_area)
    end

    sign_in_as "Check out"
  end

  test "survey questions are asked when first checked out" do
    check_out @patient, false # Don't skip the survey

    path = edit_treatment_area_patient_survey_path(@treatment_area, @patient)

    assert_current_path path
  end

  test "survey questions are not asked after a patient has been checked out" do
    @patient.check_out(@treatment_area)

    check_out @patient, false # Don't skip the survey

    path = treatment_area_patient_procedures_path(@treatment_area, @patient)

    assert_current_path path
  end

  test "procedures can be added without warnings" do
    check_out @patient

    procedure = @treatment_area.procedures.sample

    choose procedure.full_description

    fill_in 'Tooth Number:', :with => "1" if procedure.requires_tooth_number
    fill_in 'Surface Code:', :with => "F" if procedure.requires_surface_code

    click_button "Add Procedure"

    pat_proc = @patient.patient_procedures.where(:procedure_id => procedure.id)

    within "div.input-right" do
      assert_content pat_proc.first.full_description
    end

    click_button "Next"

    path = treatment_area_patient_prescriptions_path(@treatment_area, @patient)

    assert_current_path path
  end

  test "warnings are shown if no procedure has been added" do
    check_out @patient

    click_button "Next"

    assert_content "You have checked out a patient without adding any procedures."
  end

  test "warnings are shown if a procedure is entered but not added" do
    check_out @patient

    procedure = @treatment_area.procedures.sample

    choose procedure.full_description

    click_button "Next"

    assert_content "A procedure has been selected but not added."
  end

  test "procedures can be removed" do
    patient_procedure = @patient.patient_procedures.create(
      :procedure_id => @treatment_area.procedures.sample.id,
      :tooth_number => "1",
      :surface_code => "F"
    )

    check_out @patient

    assert_content patient_procedure.full_description

    find("div.procedure").find("a").click

    press_okay_in_dialog

    assert_no_content patient_procedure.full_description
  end

  test "prescriptions can be removed" do
    patient_prescription = FactoryGirl.create(:patient_prescription,
      patient: @patient)

    visit treatment_area_patient_prescriptions_path(@treatment_area, @patient)

    uncheck patient_prescription.prescription.full_description

    click_button "Finish"

    assert_content "Patient successfully checked out"

    assert @patient.patient_procedures.empty?
  end

  private

  def check_out(patient, skip_survey=true)

    if skip_survey
      visit treatment_area_patient_procedures_path(@treatment_area, patient)
    else
      visit treatment_area_patients_path(@treatment_area)

      fill_in 'Chart number', :with => patient.id

      click_button "Search"

      click_link "#{@treatment_area.name} Checkout"
    end
  end
end
