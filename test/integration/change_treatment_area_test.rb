require_relative '../test_helper'

feature "Changing the current Treatment Area" do
  before :each do
    Capybara.current_driver = Capybara.javascript_driver

    @patient                = FactoryGirl.create(:patient)
    @treatment_area         = FactoryGirl.create(:treatment_area)
    @another_treatment_area = FactoryGirl.create(:treatment_area)

    sign_in_as "Check out"
  end

  test "radiology isn't included" do
    @radiology = FactoryGirl.create(:treatment_area, name: "Radiology")

    visit treatment_areas_path

    page.wont_have_select 'treatment_area_id', 'Radiology'
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
