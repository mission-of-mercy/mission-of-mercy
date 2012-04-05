require 'test_helper'

class TreatmentTest < ActiveSupport::TestCase
  test "all_names returns an array of names" do
    t1 = FactoryGirl.create(:treatment, :name => '1')
    t2 = FactoryGirl.create(:treatment, :name => '2')

    assert_equal Treatment.all_names, [t1.name, t2.name]
  end

  test "provided_names returns an array of names of provided treatments" do
    t1 = FactoryGirl.create(:treatment, :name => '1')
    t2 = FactoryGirl.create(:treatment, :name => '2', :provided => false)
    t3 = FactoryGirl.create(:treatment, :name => '3')

    assert_equal Treatment.provided_names, [t1.name, t3.name]
  end

  test "must have a name" do
    treatment = FactoryGirl.build(:treatment, :name => nil)

    refute treatment.valid?
  end

  test "#provided? defaults to true" do
    treatment = FactoryGirl.build(:treatment)

    assert treatment.provided?
  end
end
