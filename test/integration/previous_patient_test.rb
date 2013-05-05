require_relative '../test_helper'

class PreviousPatientTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit
    @patient = FactoryGirl.create(:patient)

    sign_in_as "Check in"

    click_link "Previous patient"
  end

  test "patients can be located using chart number" do
    fill_in "Chart number", with: @patient.id

    click_button "Search"

    within("#contents") do
      assert_content @patient.id
      assert_content @patient.last_name
    end
  end

  test "patients can be located using their name" do
    fill_in "Name", with: @patient.last_name

    click_button "Search"

    within("#contents") do
      assert_content @patient.id
      assert_content @patient.last_name
    end
  end

  test "patient information is loaded into a new patient form" do
    find_and_load_previous_patient

    assert_content "This patient was previously registered using Chart #" +
                   @patient.id.to_s

    assert_equal @patient.first_name, find_field('First name').value
    assert_equal @patient.last_name,  find_field('Last name').value
    assert_equal @patient.street,     find_field('Street').value
  end

  test "previous_chart_number is set on the new patient record" do
    find_and_load_previous_patient
    finish_patient_check_in

    within('.input-bottom') { click_button "Check In" }

    new_chart = find('div.last-patient').find('h1').text

    assert_equal @patient.id, Patient.find(new_chart).previous_chart_number
  end

  test "survey questions are not asked or created" do
    find_and_load_previous_patient

    refute has_content? "Next" # as in next to survey questions

    finish_patient_check_in

    within('.input-bottom') { click_button "Check In" }

    new_chart = find('div.last-patient').find('h1').text

    refute Patient.find(new_chart).survey
  end

  private

  def find_and_load_previous_patient
    fill_in "Chart number", with: @patient.id

    click_button "Search"

    within("#contents") do
      click_link "Check-in"
    end
  end

  def finish_patient_check_in
    select 'Cleaning',   from: "Reason for today's visit"
    select 'First Time', from: 'Last dental visit'
    choose 'patient_pain_false'
  end
end
