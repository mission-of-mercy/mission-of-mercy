class PatientPreviousMomClinic < ActiveRecord::Base
  attr_accessor :attended
  
  def description
    if clinic_year
      [clinic_year, location].join(" ")
    else
      location
    end
  end
end
