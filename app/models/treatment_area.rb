class TreatmentArea < ActiveRecord::Base
  RADIOLOGY_NAME = 'Radiology'

  has_many :procedure_treatment_area_mappings
  has_many :procedures, -> { order('code') },
    through: :procedure_treatment_area_mappings
  has_many :patient_assignments
  has_many :patients, -> {
    where("checked_out_at IS NULL AND
          patient_assignments.created_at BETWEEN ? AND ?",
          Time.now.beginning_of_day.utc,
          Time.now.end_of_day.utc)
  }, through: :patient_assignments

  accepts_nested_attributes_for :procedure_treatment_area_mappings,
    :allow_destroy => true,
    :reject_if     => proc { |attributes| attributes['assigned'] == "0" }

  def self.radiology
    where(name: RADIOLOGY_NAME).first
  end

  def self.current_capacity
    order("treatment_areas.name").map do |area|
      count = area.patients(true).count || 0
      [area.name, count]
    end
  end

  def self.check_out
    if TreatmentArea.radiology
      where("id <> ?", TreatmentArea.radiology.id)
    else
      self
    end
  end

  def self.with_patients
    joins(:patients).includes(:patients).order("treatment_areas.name")
  end

  def radiology?
    name == RADIOLOGY_NAME
  end

  def patients_treated
    patients = Patient.includes(:patient_procedures => {
      :procedure => :procedure_treatment_area_mappings})
      .where("procedure_treatment_area_mappings.treatment_area_id = ?", id)

    if amalgam_composite_procedures
      patients += Patient.includes(:patient_procedures => :procedure)
        .where("procedures.procedure_type = ? OR procedures.procedure_type LIKE ?",
               "Amalgam", "%Composite")
    end

    patients.uniq
  end

end
