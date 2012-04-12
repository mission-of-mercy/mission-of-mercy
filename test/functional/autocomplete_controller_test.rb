require 'test_helper'

class AutocompleteControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    user = FactoryGirl.create(:user)
    sign_in user

    @caucasian = FactoryGirl.create(:patient, :race => "Caucasian/White")
    @californian =FactoryGirl.create(:patient, :race => "Californian")
    @indian = FactoryGirl.create(:patient, :race => "Indian")
  end

  test "should have no match for term 'xx'" do
    get(:race, :format=> 'json', :term => "xx")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.empty?)
  end

  test "should have 1 match [Indian] for term 'in'" do
    get(:race, :format=> 'json', :term => "in")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.size == 1)
    assert(response == [@indian.race])
  end

  test "should have 2 matches [Californian, Caucasian/White] for term 'ca'" do
    get(:race, :format=> 'json', :term => "ca")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.size == 2)
    assert(response == [@caucasian.race, @californian.race].sort)
  end
end

