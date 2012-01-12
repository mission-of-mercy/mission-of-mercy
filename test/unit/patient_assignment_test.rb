require 'test_helper'

class PatientAssignmentTest < ActiveSupport::TestCase

  def test_factory_should_build_valid_assignment
    a = Factory.build(:patient_assignment)
    assert a.valid?
  end

end
