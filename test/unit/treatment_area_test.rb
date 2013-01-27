require_relative '../test_helper'

class TreatmentAreaTest < ActiveSupport::TestCase

  def test_should_only_return_treatment_areas_with_patients
    patients = (1 .. 3).map { FactoryGirl.create(:patient) }
    treatment_area = FactoryGirl.create(:treatment_area)
    patients.each do |patient|
      FactoryGirl.create(:patient_assignment, patient: patient, treatment_area: treatment_area)
    end

    empty_treatment_area = FactoryGirl.create(:treatment_area)

    areas_with_patients = TreatmentArea.with_patients

    assert areas_with_patients.include?(treatment_area)
    assert !areas_with_patients.include?(empty_treatment_area)
  end

  def test_should_count_only_checked_in_patients
    radiology = FactoryGirl.create(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)

    area = FactoryGirl.create(:treatment_area)
    p1 = FactoryGirl.create(:patient)
    p2 = FactoryGirl.create(:patient)
    p3 = FactoryGirl.create(:patient)

    [p1, p2, p3].each { |p| p.assign(area.id, false) }

    assert_equal 3, area.patients.count

    p3.check_out(area)
    assert_equal 2, area.patients.count
  end

  def test_should_return_radiology_from_named_scope
    area = FactoryGirl.create(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)
    assert_equal area, TreatmentArea.radiology
  end

  def test_should_count_only_patients_assigned_today
    radiology = FactoryGirl.create(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)

    area = FactoryGirl.create(:treatment_area)
    p1 = FactoryGirl.create(:patient)
    p2 = FactoryGirl.create(:patient)

    [p1, p2].each { |p| p.assign(area.id, false) }

    assert_equal 2, area.patients.count

    Timecop.travel(2.days.from_now) do
      p3 = FactoryGirl.create(:patient)
      p3.assign(area.id, false)

      assert_equal 1, area.patients(true).count
    end
  end

  def test_should_properly_count_current_capacity
    radiology = FactoryGirl.create(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)

    area = FactoryGirl.create(:treatment_area)
    second_area = FactoryGirl.create(:treatment_area)

    3.times { FactoryGirl.create(:patient).assign(area.id, false) }
    2.times { FactoryGirl.create(:patient).assign(second_area.id, false) }

    [[radiology.name, 0], [area.name, 3], [second_area.name, 2]].each do |a|
      assert TreatmentArea.current_capacity.include?(a),
             "#{a.inspect} missing from #{TreatmentArea.current_capacity.inspect}"
    end

  end

end
