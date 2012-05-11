class Procedure < ActiveRecord::Base
  has_many :patient_procedures
  has_many :patients, :through => :patient_procedures

  has_many :procedure_treatment_area_mappings, :dependent => :delete_all
  has_many :treatment_areas, :through => :procedure_treatment_area_mappings

  validates_uniqueness_of :code
  validates_presence_of   :code

  def full_description
    "#{code}: #{description.titleize}"
  end
end
