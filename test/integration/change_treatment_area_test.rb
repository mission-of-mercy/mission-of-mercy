require 'test_helper'

class ChangeTreatmentAreaTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit

    @patient                = FactoryGirl.create(:patient)
    @treatment_area         = FactoryGirl.create(:treatment_area)
    @another_treatment_area = FactoryGirl.create(:treatment_area)

    sign_in_as "Check out"
  end

  test "from the patient search page" do
    visit treatment_area_patients_path(@treatment_area)

    change_treatment_area

    assert_current_path treatment_area_patients_path(@another_treatment_area)
  end

  test "with a chart number entered" do
    skip "The initial visit isn't keeping the params :("

    options = { patient_search: { chart_number: @patient.chart_number } }
    visit treatment_area_patients_path(@treatment_area, options)

    change_treatment_area

    assert_current_path treatment_area_patients_path(@another_treatment_area,
                                                     options)
  end

  test "from the procedures page" do
    visit treatment_area_patient_procedures_path(@treatment_area, @patient)

    change_treatment_area

    assert_current_path treatment_area_patient_procedures_path(
      @another_treatment_area, @patient)
  end

  private

  def change_treatment_area
    select @another_treatment_area.name, from: "treatment_area_id"
  end

end
