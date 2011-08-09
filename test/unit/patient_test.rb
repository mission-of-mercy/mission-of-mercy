require "test_helper"

class PatientTest < ActiveSupport::TestCase

  test "shouldn't allow more than 2 digits in state field" do
    patient = Patient.new(:state => "CTZ")

    patient.save

    assert patient.errors.invalid?(:state)

    patient.state = "CT"

    patient.save

    assert !patient.errors.invalid?(:state)
  end

  test "shouldn't allow more than 10 digits in zip field" do
    patient = Patient.new(:zip => "1234567890!")

    patient.save

    assert patient.errors.invalid?(:zip),
           "More than 10 digits allowed for zip"

    patient.zip = "1234567890"

    patient.save

    assert !patient.errors.invalid?(:zip),
           "10 or less digits are causing validation problems"
  end

  test "time in pain should set the pain_length_in_days attribute" do
    valid_formats = {
      "12d"      => 12,
      "1m"       => 30,
      "45 weeks" => 315,
      "1 year"   => 365
    }

    patient = TestHelper.valid_patient

    valid_formats.each do |format, result|
      patient.time_in_pain = format

      assert patient.save

      assert_equal result, patient.pain_length_in_days
    end
  end

  test "invalid time in pain values should cause validation errors" do
    invalid_formats = ["12dd", "1.5.1m", "45 weeks months", "about a year",
      "aaa", "123z"]

    patient = TestHelper.valid_patient

    invalid_formats.each do |format|
      patient.time_in_pain = format

      patient.save

      assert patient.errors.invalid?(:time_in_pain), "#{format} is not a valid format"
    end
  end

  test "time in pain validations should only be run if time in pain is set" do
    patient = TestHelper.valid_patient

    assert patient.save

    assert !patient.errors.invalid?(:time_in_pain)
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
end