require 'test_helper'

class CheckOutTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit

    @patient        = Factory(:patient)
    @treatment_area = Factory(:treatment_area)

    5.times do
      Factory(:procedure_treatment_area_mapping, :treatment_area => @treatment_area)
    end

    sign_in_as "Check out"
  end

  test "survey questions are asked when present" do
    check_out @patient

    path = edit_treatment_area_patient_survey_path(@treatment_area, @patient)

    assert_current_path path
  end

  test "survey questions not asked after a patient has been fully checked out" do
    @patient.update_attribute(:survey_id, nil)

    check_out @patient

    path = treatment_area_patient_procedures_path(@treatment_area, @patient)

    assert_current_path path
  end

  test "procedures can been added without warnings" do
    check_out @patient

    click_button "Next"

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

  test "warnings are shown if no procedure was been added" do
    check_out @patient

    click_button "Next"

    click_button "Next"

    assert_content "You have checked out a patient without adding any procedures."
  end

  test "warnings are show if a procedure is entered but not added" do
    check_out @patient

    click_button "Next"

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

    click_button "Next"

    assert_content patient_procedure.full_description

    find("div.procedure").find("a").click

    press_okay_in_dialog

    assert_no_content patient_procedure.full_description
  end

  private

  def check_out(patient)
    visit treatment_area_patients_path(@treatment_area)

    fill_in 'Chart number:', :with => patient.id

    click_button "Search"

    click_link "#{@treatment_area.name} Checkout"
  end
end
