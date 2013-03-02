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
      FactoryGirl.create(:survey, :age => 2, :sex => "F")
    end
  end

  it 'has a sheet for ages' do
    book.sheets.must_include "Ages"

    book.default_sheet = "Ages"

    row(1).must_equal ["Age", "Count"]

    row(2).must_equal [2, 5]
  end

  it 'has a sheet for gender' do
    book.sheets.must_include "Gender"

    book.default_sheet = "Gender"

    row(1).must_equal ["Gender", "Count"]
    row(2).must_equal ["F", 5]
  end

  it 'has a sheet for race / ethnicity' do
    book.sheets.must_include "Race"

    book.default_sheet = "Race"

    row(1).must_equal ["Race / Ethnicity", "Count"]
    row(2).must_equal ["Caucasian/White", 5]
  end

  it 'has a sheet for travel times' do
    patient = FactoryGirl.create(:patient)

    book.sheets.must_include "Travel Time"

    book.default_sheet = "Travel Time"

    row(1).must_equal ["Travel Time (in minutes)"]
    row(2).must_equal [patient.travel_time]
  end

  it 'has a sheet for previous MoM clinics' do
    3.times do
      FactoryGirl.create(:patient_previous_mom_clinic)
    end

    book.sheets.must_include "Previous MoM Clinics"

    book.default_sheet = "Previous MoM Clinics"

    row(1).must_equal ["Year", "Location", "Patient Count"]
    row(2).must_equal [2009, "New Haven", 3]
  end

  it 'has a sheet for insurance' do
    book.sheets.must_include "Insurance"

    book.default_sheet = "Insurance"

    row(1).must_equal ["Question", "Patient Count"]
    row(2).must_equal ["No insurance", 5]
  end

  it 'has a sheet for last dental visit' do
    patient = FactoryGirl.create(:patient)

    book.sheets.must_include "Last Dental Visit"

    book.default_sheet = "Last Dental Visit"

    row(1).must_equal ["Last Dental Visit", "Patient Count"]
    row(2).must_equal ["First Time", 1]
  end

  it 'has a sheet for Told More Dental Treatment Needed' do
    book.sheets.must_include "Needs More Dental Care"

    book.default_sheet = "Needs More Dental Care"

    row(1).must_equal ["Needs More Dental Care?", "Patient Count"]
    row(2).must_equal ["TRUE", 5]
  end

  it 'has a sheet for Patient has Place to Go For Dental Treatment' do
    book.sheets.must_include "Dental Treatment"

    book.default_sheet = "Dental Treatment"

    row(1).must_equal ["Has a Place to Go For Dental Treatment?", "Patient Count"]
    row(2).must_equal ["FALSE", 5]
  end
end
