require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  test "must have a category" do
    race = FactoryGirl.build(:race, :category => nil)
    refute race.valid?
  end

  test "#all_categories returns an array" do
    race1 = FactoryGirl.create(:race, :category => '1')
    race2 = FactoryGirl.create(:race, :category => '2')

    assert_equal Race.all_categories, [race1.category, race2.category]
  end
end
