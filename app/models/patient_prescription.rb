class PatientPrescription < ActiveRecord::Base
  belongs_to :patient
  belongs_to :prescription
  
  attr_accessor :prescribed
  
  def self.time_zone_aware_attributes
   false
  end
  
  def full_description
    if prescription != nil
      prescription.full_description
    else
      "Prescription"
    end
    
  end
end
