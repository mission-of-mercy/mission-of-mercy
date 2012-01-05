class Prescription < ActiveRecord::Base
  has_many :patient_prescriptions

  validates_uniqueness_of :name, :scope => :dosage
  validates_presence_of   :name

  def full_description
    if !quantity.blank? && !dosage.blank?
      [name, strength, ["#", quantity," -"].join(), dosage].join(' ')
    else
      name
    end
  end
end
