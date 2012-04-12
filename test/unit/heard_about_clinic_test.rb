require 'test_helper'

class HeardAboutClinicTest < ActiveSupport::TestCase
  test "must have a reason" do
    heard_about_clinic = FactoryGirl.build(:heard_about_clinic, :reason => nil)
    refute heard_about_clinic.valid?
  end

  test "#all_reasons returns an array" do
    heard_about_clinic1 = FactoryGirl.create(:heard_about_clinic, :reason => '1')
    heard_about_clinic2 = FactoryGirl.create(:heard_about_clinic, :reason => '2')

    assert_equal HeardAboutClinic.all_reasons, [heard_about_clinic1.reason, heard_about_clinic2.reason]
  end
end
