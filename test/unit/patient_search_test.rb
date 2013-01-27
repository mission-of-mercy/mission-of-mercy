require "test_helper"

class PatientSearchTest < ActiveSupport::TestCase

  setup do
    @jordan_byron = FactoryGirl.create(:patient,
      first_name: 'Jordan', last_name: 'Byron'
    )

    @michael_jordan = FactoryGirl.create(:patient,
      first_name: 'Michael', last_name: 'Jordan'
    )

    @patient_search = PatientSearch.new
  end

  test 'searches by chart number if it is given (even if name is given)' do
    @patient_search[:chart_number] = @jordan_byron.id
    @patient_search[:name] = 'Not the name'
    assert_equal [@jordan_byron], @patient_search.execute
  end

  test 'searches by name if given and no chart number' do
    @patient_search[:chart_number] = nil
    @patient_search[:name] = 'Jordan'
    assert_equal [@jordan_byron, @michael_jordan], @patient_search.execute
  end

  test 'if no search parameters, returns an empty active record result set' do
    assert_equal [], @patient_search.execute
    assert ActiveRecord::Relation === @patient_search.execute
  end

  test 'if the commit param is "Clear" then it returns an empty result set' do
    @patient_search[:chart_number] = @jordan_byron.id
    @patient_search[:commit]       = "Clear"

    assert_equal [], @patient_search.execute
  end

  test 'if the commit param is "Clear" then clear out search params' do
    @patient_search[:chart_number] = @jordan_byron.id
    @patient_search[:commit]       = "Clear"

    @patient_search.execute

    refute @patient_search[:chart_number]
  end

end