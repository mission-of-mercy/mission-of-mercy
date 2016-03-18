require_relative  '../test_helper'

feature "Checking in a patient" do
  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
    sign_in_as "Check in"
    click_link "No, this is a new patient"
  end

  it "must agree that the waiver has been signed before filling out form" do
    # For some reason capybara won't find this field via `field_labeled`
    # while disabled. Instead we have to use the field's ID
    #
    assert find('#patient_first_name')['disabled']
    assert find('.input-bottom input')['disabled']

    agree_to_waver

    refute field_labeled('First name')['disabled']
    refute find('.input-bottom input')['disabled']
  end

  it "does not show the waiver confirmation when returning to form for errors" do
    agree_to_waver

    within("#new_patient") do
      click_button "Next"

      refute find('.waiver_confirmation', :visible => false).visible?,
             "waiver confirmation should not be present"
      refute find_button('Next')['disabled']
             "form should be enabled"
    end
  end

  it "date of birth visible field should be text by default" do
    assert find('#date-text').visible?,
      "date of birth text input should be visible"

    refute find('#date-select', :visible => false).visible?,
      "date of birth selects should be hidden"
  end

  it "previous patients chart number should be displayed when there is one" do
    patient = FactoryGirl.create(:patient)
    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    assert find(".popup").has_content?("Patient's Chart Number")
    assert find(".popup").has_content?(patient.id.to_s)
  end

  it "button is hidden if there is no previous patient information" do
    agree_to_waver

    refute find(".same_as_previous_patient_button", :visible => false).visible?,
      "'Same as previous patient' button should be hidden"
  end

  it "display the button if previous patient information is available" do
    patient = FactoryGirl.create(:patient)

    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    within("#facebox") do
      click_link "Check In Next Patient"
    end

    click_link "No, this is a new patient"

    assert find(".same_as_previous_patient_button").visible?,
      "'Same as previous patient' button should be visible"
  end

  it "same as previous patient populates each field when clicked" do
    phone = "230-111-1111"; street = "12 St."; zip = "90210"
    city = "Beverley Hills"; state = "CA"; county = "Mezza"

    FactoryGirl.create(:zipcode, state: state,
                       zip: zip, county: county, city: city)

    patient = FactoryGirl.create(:patient, :phone => phone, :street => street,
      :zip => zip, :city => city, :state => state, :county => county)

    visit("/patients/new?last_patient_id=" + patient.id.to_s)

    within("#facebox") do
      click_link "Check In Next Patient"
    end

    click_link "No, this is a new patient"

    agree_to_waver

    click_button 'Same as previous patient'

    assert_field_value 'Phone',  phone
    assert_field_value 'Street', street
    assert_field_value 'Zip',    zip
    assert_field_value 'City',   city
    assert_field_value 'State',  state
    assert_field_value 'County', county
  end

  it "lists treatments dynamically from the treatment model" do
    options = %w[Extraction Prosthetic Bazinga]

    options.each { |name| FactoryGirl.create(:treatment, name: name) }

    visit new_patient_path

    click_link "No, this is a new patient"

    agree_to_waver

    assert has_select?("What is the reason for your visit today?",
                       :with_options => options)
  end

  it "can return to the demographic page from the survey page" do
    agree_to_waver

    fill_out_form

    click_button "Next"

    current_path.wont_equal patients_path

    assert_content "Patient Research Study"

    patient = Patient.last

    assert_equal edit_patient_survey_path(patient, patient.survey), current_path

    click_button "Back"

    assert_equal edit_patient_path(patient), current_path

    fill_in 'First name', :with => "Frank"
    fill_in 'Last name',  :with => "Pepelio"

    click_button "Next"

    assert_content "Frank Pepelio"
  end

  it "creates one survey" do
    agree_to_waver

    fill_out_form

    click_button "Next"

    assert_content "Patient Research Study"

    assert_equal 1, Survey.count
  end

  it "queues the patient's chart for printing when printers are present" do
    PrintChart.stub('printers', ['printer']) do
      visit new_patient_path
      click_link "No, this is a new patient"
      agree_to_waver
      fill_out_form

      select_printer

      click_button "Next"

      page.must_have_content "Printing Chart"

      # Find the patient from the database
      patient = Patient.order("created_at DESC").first
      assert_queued PrintChart, [patient.id, "printer"]
    end
  end

  it "falls back to old pop-up printing method when queue is offline" do
    agree_to_waver
    fill_out_form

    click_button "Next"

    page.must_have_content "Printing Chart"
  end

  it "asks if the patient has already been through the clinic" do
    visit new_patient_path

    page.must_have_content "Has the patient already been through the clinic?"
  end

  private

  def agree_to_waver
    click_button "waiver_agree_button"
  end

  def fill_out_form
    fill_in 'First name',                :with => 'Jordan'
    fill_in 'Last name',                 :with => 'Byron'
    fill_in 'Date of birth',             :with => '12/26/1985'
    select  'M',                         :from => 'Sex'
    fill_in 'City',                      :with => 'Cheshire'
    select  'CT',                        :from => 'State'
    select  'New Haven',                 :from => 'County'
    select  'Cleaning',                  :from => "patient_chief_complaint"
    select  'Excellent',                 :from => 'patient_overall_health'
    select  'English',                   :from => 'Language'
    choose  'patient_consent_to_research_study_true'
    choose  'patient_pain_false'
  end
end
