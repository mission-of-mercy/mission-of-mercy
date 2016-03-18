require_relative "../test_helper"

class PatientTest < ActiveSupport::TestCase

  def setup
    super
    @radiology = FactoryGirl.create(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)
  end

  test "should not allow more than two digits in the state field" do
    patient = FactoryGirl.build(:patient, :state => "CTZ")

    patient.save

    assert patient.errors[:state].any?

    patient.state = "CT"

    patient.save

    assert patient.errors[:state].none?
  end

  test "should not allow more than 10 digits in the zip field" do
    patient = FactoryGirl.build(:patient, :zip => "1234567890!")

    patient.save

    assert patient.errors[:zip].any?,
           "More than 10 digits allowed for zip"

    patient.zip = "1234567890"

    patient.save

    assert patient.errors[:zip].none?,
           "10 or less digits are causing validation problems"
  end

  test "text entry for date of birth should accept reasonable date formats" do
    valid_formats = {
      "05/23/2008"    => Date.civil(2008, 5, 23),
      "05-23-2008"    => Date.civil(2008, 5, 23),
      "05.23.2008"    => Date.civil(2008, 5, 23),
    }

    patient = TestHelper.valid_patient

    valid_formats.each do |format, result|
      patient.date_of_birth = format

      assert patient.save, "Couldn't save Patient with date_of_birth value #{ format }"

      assert_equal result, patient.date_of_birth
    end
  end

  test "text entry for date of birth should not accept invalid date formats" do
    patient = TestHelper.valid_patient

    invalid_formats = %w{23/1/1 1/1/98}

    invalid_formats.each do |format|
      patient.date_of_birth = format

      refute patient.save, "Saving an invalid date format: #{format}"
    end
  end

  test "should properly assign treatment area" do
    patient = FactoryGirl.create(:patient)
    area = FactoryGirl.create(:treatment_area)

    patient.assign(area.id, false)

    assert_equal 1, patient.assignments.count
    assert_equal area, patient.assignments[0].treatment_area
  end

  test "should return area to which patient is assigned" do
    patient = FactoryGirl.create(:patient)
    area = FactoryGirl.create(:treatment_area)

    patient.assign(area.id, false)

    assert_equal area, patient.assigned_to[0]
  end

  test "should allow for assigning to multiple areas" do
    patient = FactoryGirl.create(:patient)
    area = FactoryGirl.create(:treatment_area)

    patient.assign(area.id, true)

    assert_equal [@radiology, area], patient.assigned_to
  end

  test "should allow for assigning to radiology only" do
    patient = FactoryGirl.create(:patient)

    patient.assign(nil, true)

    assert_equal [@radiology], patient.assigned_to
  end

  test "should allow check out" do
    area = FactoryGirl.create(:treatment_area)
    patient = FactoryGirl.create(:patient)

    patient.assign(area.id, false)
    assert_equal area, patient.assigned_to[0]

    patient.check_out(area)
    assert patient.assigned_to.empty?
  end

  test "checks out of radiology" do
    radiology = TreatmentArea.where(name: TreatmentArea::RADIOLOGY_NAME).
                  first_or_create
    area      = FactoryGirl.create(:treatment_area)
    patient   = FactoryGirl.create(:patient)

    patient.assign(area.id, true)

    patient.check_out(radiology)
    assert_equal [area], patient.assigned_to
  end

  test "checks out of both radiology and a treatment area" do
    radiology = TreatmentArea.where(name: TreatmentArea::RADIOLOGY_NAME).
                  first_or_create
    area      = FactoryGirl.create(:treatment_area)
    patient   = FactoryGirl.create(:patient)

    patient.assign(area.id, true)

    patient.check_out(area)
    assert patient.assigned_to.empty?
  end

  test "should save check out time" do
    area = FactoryGirl.create(:treatment_area)
    patient = FactoryGirl.create(:patient)

    assert patient.assign(area, false)
    assert_nil patient.assignments.last.checked_out_at

    patient.check_out(area)
    assert_not_nil patient.assignments.last.checked_out_at
  end

  test "should check if patient is assigned to area" do
    patient = FactoryGirl.create(:patient)
    area = FactoryGirl.create(:treatment_area)

    patient.assign(area, false)

    assert patient.assigned_to?(area)
    assert_equal false, patient.assigned_to?(FactoryGirl.create(:treatment_area))
  end

  test "should remove radiology assignment" do
    patient = FactoryGirl.create(:patient)

    patient.assign(nil, true)
    assert_equal 1, patient.assigned_to.size

    patient.assign(nil, false)
    assert patient.assigned_to.empty?
  end

  test "should change assigned area" do
    patient = FactoryGirl.create(:patient)
    area1 = FactoryGirl.create(:treatment_area)
    area2 = FactoryGirl.create(:treatment_area)

    patient.assign(area1.id, false)
    assert_equal area1, patient.assigned_to[0]

    patient.assign(area2.id, false)
    assert_equal area2, patient.assigned_to[0]
  end

  test "reassigning should return true" do
    patient = FactoryGirl.create(:patient)
    area1 = FactoryGirl.create(:treatment_area)
    area2 = FactoryGirl.create(:treatment_area)

    assert patient.assign(area1.id, false)
    assert patient.assign(area1.id, true)
    assert patient.assign(area2.id, true)
    assert patient.assign(area2.id, true)
    assert patient.assign(area2.id, false)
  end

  test "shouldn't destroy checked out assignments" do
    patient = FactoryGirl.create(:patient)
    area1 = FactoryGirl.create(:treatment_area)
    area2 = FactoryGirl.create(:treatment_area)

    patient.assign(area1.id, false)
    patient.check_out(area1)
    assert_equal 1, patient.assignments.count

    patient.assign(area2.id, false)
    assert_equal 2, patient.assignments.count
  end
end
