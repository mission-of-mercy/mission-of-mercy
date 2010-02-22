class Prescription < ActiveRecord::Base
  has_many :patient_prescriptions
  
  def self.time_zone_aware_attributes
   false
  end
  
  def full_description
    if quantity != nil && dosage != nil
      [name, strength, ["#", quantity," -"].join(), dosage].join(' ')
    else
      name
    end
  end
end
