require 'test_helper'

class TreatmentAreaTest < ActiveSupport::TestCase

  def test_should_count_only_checked_in_patients
    area = Factory(:treatment_area)
    p1 = Factory(:patient)
    p2 = Factory(:patient)
    p3 = Factory(:patient)

    [p1, p2, p3].each { |p| p.check_in(area) }

    assert_equal 3, area.patients.count

    p3.check_out(area)
    assert_equal 2, area.patients.count
  end

end
