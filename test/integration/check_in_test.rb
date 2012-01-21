require 'test_helper'

class CheckInTest < ActionDispatch::IntegrationTest
  test "must agree that the waiver has been signed before filling out form" do
    Capybara.current_driver = :selenium

    sign_in_as "Check in"
    assert_equal find_field('First name')[:disabled], "true"
    assert_equal find_button('Next')[:disabled], "true"

    click_button "Agree"
    assert_equal find_field('First name')[:disabled], "false"
    assert_equal find_button('Next')[:disabled], "false"
  end

  test "does not show the waiver confirmation when returning to form for errors" do
    Capybara.current_driver = :selenium

    sign_in_as "Check in"
    click_button "Agree"
    click_button "Next"
    click_button "Check In"

    refute find('.waiver_confirmation').visible?, "waiver confirmation should not be visible"
    assert_equal find_button('Next')[:disabled], "false", "form should be enabled"
  end

  test "previous patients chart should be printed when there is one" do
    Capybara.current_driver = :selenium

    patient = Factory(:patient)
    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".popup").has_content?("Patient's Chart Number")
    assert find(".popup").has_content?(patient.id.to_s)
  end

  test "the button should not be visible if there is no previous patient information" do
    Capybara.current_driver = :selenium

    sign_in_as "Check in"
    click_button "Agree"
    refute find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be hidden"
  end

  test "should display the button if previous patient information is available" do
    Capybara.current_driver = :selenium

    patient = Factory(:patient)
    sign_in_as "Check in"
    click_button "Agree"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be visible"
  end

  test "populates each field when clicked" do
    Capybara.current_driver = :selenium

    phone = "230-111-1111"; street = "12 St."; zip = "90210"
    city = "Beverley Hills"; state = "CA"

    patient = Factory(:patient, :phone => phone, :street => street, :zip => zip,
                      :city => city, :state => state)

    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)
    click_link "Check In Next Patient"
    click_button "Agree"

    click_button 'Same as previous patient'

    assert_equal find_field('Phone').value, phone
    assert_equal find_field('Street').value, street
    assert_equal find_field('Zip').value, zip
    assert_equal find_field('City').value, city
    assert_equal find_field('State').value, state
  end
end
