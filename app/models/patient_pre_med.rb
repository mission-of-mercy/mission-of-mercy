class PatientPreMed < ActiveRecord::Base
  belongs_to :pre_med
  belongs_to :patient
  
  attr_accessor :prescribed
end
