class PatientFlow < ActiveRecord::Base
  belongs_to :patient
  belongs_to :treatement_area

  
end
