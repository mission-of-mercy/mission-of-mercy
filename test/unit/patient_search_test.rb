require_relative "../test_helper"

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

  test 'search by chart number if it is given (even if name is given)' do
    @patient_search.chart_number = @jordan_byron.id
    @patient_search.name = 'Not the name'
    assert_equal [@jordan_byron], @patient_search.execute
  end

  test 'search by name if given and no chart number' do
    @patient_search.chart_number = nil
    @patient_search.name = 'Jordan'
    assert_equal [@jordan_byron, @michael_jordan], @patient_search.execute
  end

  test 'search by assigned treatment area' do
    @treatment_area = FactoryGirl.create(:treatment_area)
    @other_treatment_area = FactoryGirl.create(:treatment_area)
    @jordan_byron.treatment_areas << @treatment_area
    @michael_jordan.treatment_areas << @other_treatment_area

    @patient_search.treatment_area_id = @treatment_area.id
    assert_equal [@jordan_byron], @patient_search.execute

    @patient_search.treatment_area_id = @other_treatment_area.id
    assert_equal [@michael_jordan], @patient_search.execute
  end

  test 'search by age' do
  end

  test 'search by procedure' do

  end

  test 'combine search options (except chart number)' do
    # Should be able to combine any search options other than chart number
  end

  test 'if no search parameters, returns an empty active record result set' do
    assert_equal [], @patient_search.execute
    assert ActiveRecord::Relation === @patient_search.execute
  end

  test 'if the commit param is Clear then it returns an empty result set' do
    @patient_search.chart_number = @jordan_byron.id
    @patient_search.commit       = 'Clear'

    puts @patient_search.commit

    assert_equal [], @patient_search.execute
  end

  test 'if the commit param is Clear then clear out search params' do
    @patient_search.chart_number = @jordan_byron.id
    @patient_search.commit       = "Clear"

    @patient_search.execute

    refute @patient_search.chart_number
  end

  test '#blank_search? returns true when there are no search params' do
    assert @patient_search.blank_search?
  end
end
