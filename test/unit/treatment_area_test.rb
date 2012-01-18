require 'test_helper'

class TreatmentAreaTest < ActiveSupport::TestCase

  def test_should_count_only_checked_in_patients
    area = Factory(:treatment_area)
    p1 = Factory(:patient)
    p2 = Factory(:patient)
    p3 = Factory(:patient)

    [p1, p2, p3].each { |p| p.assign(area.id, false) }

    assert_equal 3, area.patients.count

    p3.check_out(area.id)
    assert_equal 2, area.patients.count
  end

  def test_should_return_radiology_from_named_scope
    area = Factory(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)
    assert_equal area, TreatmentArea.radiology
  end

  # TODO kbl
  # again time zone issue ):
  # on rails console everything is ok, but here with my setup test fails
  def test_should_count_only_patients_checked_in_in_the_same_day
    area = Factory(:treatment_area)
    p1 = Factory(:patient, created_at: Time.zone.now - 2.day)
    p2 = Factory(:patient)
    p3 = Factory(:patient)

    [p1, p2, p3].each { |p| p.assign(area.id, false) }

    assert_equal 2, area.patients.count
  end

  def test_should_properly_count_current_capacity
    area = Factory(:treatment_area)
    second_area = Factory(:treatment_area)

    3.times { Factory(:patient).assign(area.id, false) }
    2.times { Factory(:patient).assign(second_area.id, false) }

    assert_equal [[area.name, 3], [second_area.name, 2]], TreatmentArea.current_capacity
  end

end
