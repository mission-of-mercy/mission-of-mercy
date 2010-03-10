class PatientPreviousMomClinic < ActiveRecord::Base
  attr_accessor :attended
  
  def description
    if year
      [year, location].join(" ")
    else
      location
    end
  end
end
