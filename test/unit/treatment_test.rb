require 'test_helper'

class TreatmentTest < ActiveSupport::TestCase
  test "all_names returns an array of names" do
    t1 = FactoryGirl.create(:treatment, :name => '1')
    t2 = FactoryGirl.create(:treatment, :name => '2')

    assert_equal Treatment.all_names, [t1.name, t2.name]
  end

  test "must have a name" do
    treatment = FactoryGirl.build(:treatment, :name => nil)

    refute treatment.valid?
  end
end
