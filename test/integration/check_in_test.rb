require 'test_helper'

class CheckInTest < ActionDispatch::IntegrationTest
  test "redirected to new patient path on login" do
    sign_in_as "Check in"
    assert_current_path new_patient_path
  end
end
