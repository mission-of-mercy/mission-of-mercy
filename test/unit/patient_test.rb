require "test_helper"

class PatientTest < ActiveSupport::TestCase

  test "shouldn't allow more than 2 digits in state field" do
    patient = Patient.new(:state => "CTZ")

    patient.save

    assert patient.errors[:state].any?

    patient.state = "CT"

    patient.save

    assert patient.errors[:state].none?
  end

  test "shouldn't allow more than 10 digits in zip field" do
    patient = Patient.new(:zip => "1234567890!")

    patient.save

    assert patient.errors[:zip].any?,
           "More than 10 digits allowed for zip"

    patient.zip = "1234567890"

    patient.save

    assert patient.errors[:zip].none?,
           "10 or less digits are causing validation problems"
  end

  test "time in pain should set the pain_length_in_days attribute" do
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

  test "travel time is calculated" do
    patient = TestHelper.valid_patient

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

      assert patient.save, "Couldn't save Patient with date_of_birth value = #{ format }"

      assert_equal result, patient.date_of_birth
    end
  end

  test "text entry for date of birth should not accept invalid date formats" do
    patient = TestHelper.valid_patient

    patient.date_of_birth = "23/1/1"

    assert !patient.save,
      "Saved patient with an invalid date_of_birth value"

  end
end
