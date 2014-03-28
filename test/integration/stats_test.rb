require_relative '../test_helper'

feature "Stats" do
  before do
    Capybara.current_driver = Capybara.javascript_driver
  end

  describe "Check In" do
    it "displays a message after each successful check in" do
      user = simulated_user("Check in").sign_in

      user.register_a_new_patient

      page.must_have_content "checked in 1 patient"

      user
        .close_previous_patient_facebox
        .register_a_new_patient

      page.must_have_content "checked in 2 patients"
    end
  end
end
