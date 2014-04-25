require_relative  '../test_helper'

feature "Help links for users" do
  let(:patient)        { FactoryGirl.create(:patient) }
  let(:treatment_area) { FactoryGirl.create(:treatment_area,
                          amalgam_composite_procedures: true) }

  before do
    Capybara.current_driver = Capybara.javascript_driver

    sign_in_as "Check out"
    check_out  patient
  end

  it "displays help related to the tobacco field" do
    find("#tobacco-help-icon").click

    page.must_have_selector("#tobacco-help", visible: true)
  end

  private

  def check_out(patient)
    visit treatment_area_patients_path(treatment_area)

    fill_in 'Chart number', :with => patient.id

    click_button "Search"

    click_link "#{treatment_area.name} Checkout"
  end
end
