require "test_helper"

class PatientTest < ActiveSupport::TestCase
  
  test "shouldn't allow more than 2 digits in state field" do
    patient = Patient.new(:state => "CTZ")
    
    patient.save
    
    assert patient.errors.select {|field, message| field == "state" }.any?
    
    patient.state = "CT"
    
    patient.save
    
    assert patient.errors.select {|field, message| field == "state" }.empty?
  end
  
  test "shouldn't allow more than 10 digits in zip field" do
    patient = Patient.new(:zip => "1234567890!")
    
    patient.save
    
    assert patient.errors.select {|field, message| field == "zip" }.any?,
           "More than 10 digits allowed for zip"
    
    patient.zip = "1234567890"
    
    patient.save
    
    assert patient.errors.select {|field, message| field == "zip" }.empty?,
           "10 or less digits are causing validation problems"
  end
end