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

  test "time in pain should set the pain length in the days attribute" do
    valid_formats = {
      "12d"      => 12,
      "1m"       => 30,
      "45 weeks" => 315,
      "1 year"   => 365,
      "4 Months"  => 120,
      "1W   "     => 7,
      "6Months"   => 180,
      "0days"     => 0,
      "03w"       => 21,
      "1.5months" => 30,
      "0.5days"   => 1,
      ".9 Months" => 0
    }

    patient = TestHelper.valid_patient

    valid_formats.each do |format, result|
      patient.time_in_pain = format

      assert patient.save, "Couldn't save Patient with time_in_pain value = #{ format }"

      assert_equal result, patient.pain_length_in_days
    end
  end

  test "invalid time in pain values should cause validation errors" do
    invalid_formats = ["12dd", "1.5.1m", "45 weeks months", "about a year",
      "15 minutes", "aaa", "123z"]

    patient = TestHelper.valid_patient

    invalid_formats.each do |format|
      patient.time_in_pain = format

      assert !patient.save, "Patient was saved with time_in_pain format = #{ format }"

      assert patient.errors[:time_in_pain].any?, "#{format} is not a valid format"
    end
  end

  test "time in pain validations should only be run if time in pain is set" do
    patient = TestHelper.valid_patient

    assert patient.save

    assert patient.errors[:time_in_pain].none?
  end

  test "travel time is calculated correctly" do
    patient = FactoryGirl.build(:patient, travel_time: 0)

    patient.travel_time_minutes = 15

    assert_equal 15, patient.travel_time_minutes

    assert_equal 15, patient.travel_time

    assert patient.save

    patient.travel_time_hours = "1"

    assert_equal 1, patient.travel_time_hours

    assert_equal 75, patient.travel_time

    assert patient.save
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
