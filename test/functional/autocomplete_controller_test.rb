require 'test_helper'

class AutocompleteControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    user = FactoryGirl.create(:user)
    sign_in user
  end

  test "autocomplete race should have no match for term 'xx'" do
    init_patient
    get(:race, :format=> 'json', :term => "xx")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.empty?)
  end

  test "autocomplete race should have 1 match [Indian] for term 'in'" do
    init_patient
    get(:race, :format=> 'json', :term => "in")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.size == 1)
    assert(response == [@indian.race])
  end

  test "autocomplete race should have 2 matches [Californian, Caucasian/White] for term 'ca'" do
    init_patient
    get(:race, :format=> 'json', :term => "ca")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.size == 2)
    assert(response == [@caucasian.race, @californian.race].sort)
  end

  test "autocomplete heard about clinic should have no match for term 'xx'" do
    init_survey
    get(:heard_about_clinic, :format=> 'json', :term => "xx")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.empty?)
  end

  test "autocomplete heard about clinic should have 1 match [Radio] for term 'ra'" do
    init_survey
    get(:heard_about_clinic, :format=> 'json', :term => "ra")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.size == 1)
    assert(response == [@radio.heard_about_clinic])
  end

  test "autocomplete heard about clinic should have 2 matches [Flyer or Poster, Friends or Family] for term 'f'" do
    init_survey
    get(:heard_about_clinic, :format=> 'json', :term => "f")
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response.size == 2)
    assert(response == [@friends.heard_about_clinic, @flyer.heard_about_clinic].sort)
  end

  private
  def init_survey
    @friends = FactoryGirl.create(:survey, :heard_about_clinic => "Friends or Family")
    @flyer = FactoryGirl.create(:survey, :heard_about_clinic => "Flyer or Poster")
    @radio = FactoryGirl.create(:survey, :heard_about_clinic => "Radio")
  end
  def init_patient
    @caucasian = FactoryGirl.create(:patient, :race => "Caucasian/White")
    @californian =FactoryGirl.create(:patient, :race => "Californian")
    @indian = FactoryGirl.create(:patient, :race => "Indian")
  end
end

