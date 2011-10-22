class TreatmentArea < ActiveRecord::Base
  has_many :procedure_treatment_area_mappings
  has_many :procedures, :through => :procedure_treatment_area_mappings,
                        :order   => "code"
  has_many :patients, :foreign_key => "assigned_treatment_area_id"
  
  accepts_nested_attributes_for :procedure_treatment_area_mappings, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['assigned'] == "0" }

  def self.radiology
    TreatmentArea.find(:first, :conditions => {:name => "Radiology"})
  end
  
  def radiology?
    name == "Radiology"
  end
  
  def patients_treated
    patients = Patient.all(
      :include    => [:patient_procedures => {:procedure => :procedure_treatment_area_mappings}],
      :conditions => ["procedure_treatment_area_mappings.treatment_area_id = ?", id]
    )
    
    if amalgam_composite_procedures
      patients += Patient.all(
        :include    => [:patient_procedures => :procedure],
        :conditions => ["procedures.procedure_type = ? OR procedures.procedure_type LIKE ?", "Amalgam", "%Composite"]
      )
    end
    
    patients.uniq
  end
end
