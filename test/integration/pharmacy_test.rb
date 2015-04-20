require_relative  '../test_helper'

feature "Pharmacy Checkout" do
  let(:patient) { FactoryGirl.create(:patient) }
  let(:prescription) { FactoryGirl.create(:prescription) }

  before do
    Capybara.current_driver = Capybara.javascript_driver

    sign_in_as "Pharmacy"

    visit pharmacy_path

    fill_in 'Chart number', :with => patient.id

    click_button "Search"
  end

  test "prescriptions can be removed" do
    patient_prescription = FactoryGirl.create(:patient_prescription,
      patient: patient)

    click_link "Check out"

    uncheck patient_prescription.prescription.full_description

    click_button "Finish"

    assert_content "Prescriptions sucessfully added"

    patient.patient_prescriptions.empty?.must_equal true
  end

  test "prescriptions can be added" do
    prescription # Create the prescription

    click_link "Check out"

    check prescription.full_description

    click_button "Finish"

    assert_content "Prescriptions sucessfully added"

    patient.patient_prescriptions.count.must_equal 1
  end

end
