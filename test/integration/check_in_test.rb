require 'test_helper'

class CheckInTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit
  end

  test "must agree that the waiver has been signed before filling out form" do
    sign_in_as "Check in"
    assert_equal find_field('First name')[:disabled], "true"
    assert_equal find_button('Next')[:disabled], "true"

    agree_to_waver

    assert_equal find_field('First name')[:disabled], "false"
    assert_equal find_button('Next')[:disabled], "false"
  end

  test "does not show the waiver confirmation when returning to form for errors" do
    sign_in_as "Check in"

    agree_to_waver
    click_button "Next"
    click_button "Check In"

    refute find('.waiver_confirmation').visible?, "waiver confirmation should not be visible"
    assert_equal find_button('Next')[:disabled], "false", "form should be enabled"
  end

  test "previous patients chart should be printed when there is one" do
    patient = Factory(:patient)
    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".popup").has_content?("Patient's Chart Number")
    assert find(".popup").has_content?(patient.id.to_s)
  end

  test "the button should not be visible if there is no previous patient information" do
    sign_in_as "Check in"

    agree_to_waver

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
    click_link "Check In Next Patient"

    agree_to_waver

    click_button 'Same as previous patient'

    assert_field_value 'Phone',  phone
    assert_field_value 'Street', street
    assert_field_value 'Zip',    zip
    assert_field_value 'City',   city
    assert_field_value 'State',  state
  end

  test "lists treatments dynamically from the treatment model" do
    t1 = Factory(:treatment, :name => 'treatment 1')
    t2 = Factory(:treatment, :name => 'treatment 2')
    t3 = Factory(:treatment, :name => 'treatment 3')

    sign_in_as "Check in"
    select = find('#patient_chief_complaint')
    assert select.has_content? t1.name
    assert select.has_content? t2.name
    assert select.has_content? t3.name
  end

  private

  def agree_to_waver
    click_button "waiver_agree_button"
  end
end
