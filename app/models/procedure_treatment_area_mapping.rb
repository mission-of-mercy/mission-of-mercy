class ProcedureTreatmentAreaMapping < ActiveRecord::Base
  belongs_to :procedure
  belongs_to :treatement_area
  
  attr_accessor :assigned
end
