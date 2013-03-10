require 'test_helper'
require_relative '../../support/excel_helpers'

DatabaseCleaner.strategy = :transaction

describe Reports::Ada do
  include ExcelHelpers

  let(:tempfile)   { File.join(Dir.mktmpdir, "ada_report#{Time.now.to_i}.xlsx") }
  let(:report_xls) { Reports::Ada.new.render_to_path(tempfile) }
  let(:book)       { report_xls; Roor::Excelx.new(tempfile) }

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  before do
    5.times do
      patient = FactoryGirl.create(:patient,
        date_of_birth: Date.today - 2.years, sex: "F")
      patient.survey.update_attributes(age: 2, sex: "F")
    end
  end

  # Sanity Check
  #
  it 'reports data for all patients with surveys' do
    book.sheets.must_include "Mission of Mercy"

    book.default_sheet = "Mission of Mercy"

    row(1).must_include "Age"
  end

  describe 'SurveyPresenter' do
    before do
      @survey = Survey.first
      @survey_presenter = Reports::Ada::SurveyPresenter.new(@survey)
    end

    it "is vaild when a patient can be found" do
      @survey_presenter.valid?.must_equal true
    end

    it "is invalid when a patient does not exist" do
      survey = FactoryGirl.create(:survey)

      survey_presenter = Reports::Ada::SurveyPresenter.new(survey)

      survey_presenter.valid?.must_equal false
    end
  end
end
