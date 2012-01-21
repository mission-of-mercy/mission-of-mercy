require 'test_helper'

class CheckInTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit
  end

  test "must agree that the waiver has been signed before filling out form" do
    sign_in_as "Check in"
    assert_equal find_field('First name')[:disabled], "true"
    assert_equal find_button('Next')[:disabled], "true"

    check "Agree"
    assert_equal find_field('First name')[:disabled], "false"
    assert_equal find_button('Next')[:disabled], "false"
  end

  test "the button should not be visible if there is no previous patient information" do
    sign_in_as "Check in"

    assert_current_path new_patient_path

    refute find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be hidden"
  end

  test "should display the button if previous patient information is available" do
    patient = Factory(:patient)
    sign_in_as "Check in"

    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be visible"
  end

  test "populates each field when clicked" do
    phone = "230-111-1111"; street = "12 St."; zip = "90210"
    city = "Beverley Hills"; state = "CA"

    patient = Factory(:patient, :phone => phone, :street => street, :zip => zip,
                      :city => city, :state => state)

    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)
    check "Agree"

    click_button 'Same as previous patient'

    assert_field_value 'Phone',  phone
    assert_field_value 'Street', street
    assert_field_value 'Zip',    zip
    assert_field_value 'City',   city
    assert_field_value 'State',  state
  end

  test "previous patient chart number is displayed after sucessful checkin" do
    patient = Factory(:patient)
    sign_in_as "Check in"

    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert_equal patient.id.to_s, find("#facebox div.top h1").text
  end
end
