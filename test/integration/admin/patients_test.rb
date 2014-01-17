require 'test_helper'

class AdminPatientsTest < ActionDispatch::IntegrationTest

  def setup
    Capybara.current_driver = Capybara.javascript_driver
    sign_in_as 'Admin'
    @patient = FactoryGirl.create(:patient)
  end

  test "date of birth field is properly parsed when editing patients" do
    visit edit_admin_patient_path(@patient)

    click_button "Update"

    assert_current_path admin_patients_path
  end

end
