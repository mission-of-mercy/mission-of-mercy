class ProcedureTreatmentAreaMapping < ActiveRecord::Base
  belongs_to :procedure
  belongs_to :treatment_area
  
  attr_accessor :assigned
end
