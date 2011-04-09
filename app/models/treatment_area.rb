class TreatmentArea < ActiveRecord::Base
  has_many :procedure_treatment_area_mappings, :dependent => :delete_all
  has_many :procedures, :through => :procedure_treatment_area_mappings
  has_many :patients, :foreign_key => "assigned_treatment_area_id"
  
  accepts_nested_attributes_for :procedure_treatment_area_mappings, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['assigned'] == "0" }

  def self.radiology
    TreatmentArea.find(:first, :conditions => {:name => "Radiology"})
  end
  
  def prosthetics?
    name == "Prosthetics"
  end
  
  def radiology?
    name == "Radiology"
  end
end
