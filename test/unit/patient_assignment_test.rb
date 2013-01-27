require_relative '../test_helper'

class PatientAssignmentTest < ActiveSupport::TestCase

  def test_should_return_not_checked_out_entries
    a1 = FactoryGirl.create(:patient_assignment)
    a2 = FactoryGirl.create(:patient_assignment, checked_out_at: Time.now)

    assert_equal [a1], PatientAssignment.not_checked_out
  end

end
