class Procedure < ActiveRecord::Base
  has_many :patient_procedures
  has_many :patients, :through => :patient_procedures
  #has_many :procedure_surface_codes
  #has_many :procedure_tooth_numbers
  
  belongs_to :treatement_area
  
  def self.time_zone_aware_attributes
   false
  end
  
  def full_description
    [code,": ", description].join()
  end
end
