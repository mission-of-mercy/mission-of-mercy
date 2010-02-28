class Procedure < ActiveRecord::Base
  has_many :patient_procedures
  has_many :patients, :through => :patient_procedures
  
  belongs_to :treatement_area
  
  def full_description
    [code,": ", description].join()
  end
end
