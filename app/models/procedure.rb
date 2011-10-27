class Procedure < ActiveRecord::Base
  has_many :patient_procedures
  has_many :patients, :through => :patient_procedures

  has_many :procedure_treatment_area_mappings, :dependent => :delete_all
  has_many :treatment_areas, :through => :procedure_treatment_area_mappings

  def full_description
    "#{code}: #{description}"
  end
end
