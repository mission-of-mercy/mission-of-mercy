require 'test_helper'

class CheckInTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit
  end

  test "must agree that the waiver has been signed before filling out form" do
    sign_in_as "Check in"

    # For some reason capybara won't find this field via `field_labeled`
    # while disabled. Instead we have to use the field's ID
    #
    assert find('#patient_first_name')['disabled']
    assert find('.input-bottom input')['disabled']

    agree_to_waver

    refute field_labeled('First name')['disabled']
    refute find('.input-bottom input')['disabled']
  end

  test "does not show the waiver confirmation when returning to form for errors" do
    sign_in_as "Check in"

    agree_to_waver

    within("#new_patient") do
      click_button "Next"

      refute find('.waiver_confirmation').visible?,
             "waiver confirmation should not be present"
      refute find_button('Next')['disabled']
             "form should be enabled"
    end
  end

  test "date of birth visible field should be text by default" do
    sign_in_as "Check in"

    assert find('#date-text').visible?,
      "date of birth text input should be visible"

    refute find('#date-select').visible?,
      "date of birth selects should be hidden"
  end


  test "previous patients chart should be printed when there is one" do
    patient = FactoryGirl.create(:patient)
    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".popup").has_content?("Patient's Chart Number")
    assert find(".popup").has_content?(patient.id.to_s)
  end

  test "button is hidden if there is no previous patient information" do
    sign_in_as "Check in"

    agree_to_waver

    refute find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be hidden"
  end

  test "display the button if previous patient information is available" do
    patient = FactoryGirl.create(:patient)
    sign_in_as "Check in"

    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be visible"
  end

  test "same as previous patient populates each field when clicked" do
    phone = "230-111-1111"; street = "12 St."; zip = "90210"
    city = "Beverley Hills"; state = "CA"

    patient = FactoryGirl.create(:patient, :phone => phone, :street => street, :zip => zip,
                                 :city => city, :state => state)

    sign_in_as "Check in"
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    within("#facebox") do
      click_link "Check In Next Patient"
    end

    agree_to_waver

    click_button 'Same as previous patient'

    assert_field_value 'Phone',  phone
    assert_field_value 'Street', street
    assert_field_value 'Zip',    zip
    assert_field_value 'City',   city
    assert_field_value 'State',  state
  end

  test "lists treatments dynamically from the treatment model" do
    options = %w[Extraction Prosthetic Bazinga]

    options.each { |name| FactoryGirl.create(:treatment, name: name) }

    sign_in_as "Check in"

    agree_to_waver

    assert has_select?("Reason for today's visit", :with_options => options)
  end

  test "can return to the demographic page from the survey page" do
    sign_in_as "Check in"

    agree_to_waver

    fill_out_form

    click_button "Next"

    patient = Patient.last until patient.present?

    assert_equal new_patient_survey_path(patient), current_path

    click_button "Back"

    assert_equal edit_patient_path(patient), current_path

    fill_in 'First name', :with => "Frank"
    fill_in 'Last name',  :with => "Pepelio"

    click_button "Next"

    assert_content "Frank Pepelio"
  end

  private

  def agree_to_waver
    click_button "waiver_agree_button"
  end

  def fill_out_form
    fill_in 'First name',                :with => "Jordan"
    fill_in 'Last name',                 :with => "Byron"
    fill_in 'Date of birth',             :with => "12/26/1985"
    select  "M",                         :from => 'Sex'
    select  "Caucasian/White",           :from => 'Race'
    fill_in 'City',                      :with => "Norwalk"
    fill_in 'State',                     :with => "CT"
    select  'Cleaning',                  :from => "Reason for today's visit"
    select  "First Time",                :from => 'Last dental visit'
    fill_in 'patient_travel_time_hours', :with => "1"
    choose 'patient_pain_false'
  end
end
