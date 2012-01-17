class TreatmentArea < ActiveRecord::Base

  RADIOLOGY_NAME = 'Radiology'

  has_many :procedure_treatment_area_mappings
  has_many :procedures, through: :procedure_treatment_area_mappings,
                        order: 'code'
  has_many :patient_assignments
  has_many :patients, through: :patient_assignments,
                      conditions: [
                        'checked_out_at IS NULL AND patient_assignments.created_at BETWEEN ? AND ?',
                        Time.now.beginning_of_day,
                        Time.now.end_of_day]

  accepts_nested_attributes_for :procedure_treatment_area_mappings, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['assigned'] == "0" }

  def self.radiology
    where(name: RADIOLOGY_NAME).first
  end

  def self.current_capacity
    all.map do |area|
      count = area.patients.count || 0
      [area.name, count]
    end
  end

  def radiology?
    name == RADIOLOGY_NAME
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
