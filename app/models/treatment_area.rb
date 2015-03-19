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

  def self.average_processing_time_in_seconds
    where("name <> ?", RADIOLOGY_NAME).all.map do |t|
      t.weighted_average_processing_time_in_seconds
    end.compact.sum
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

  # Calculates today's averge processing time (Time from check in to check out)
  # for this treatment area
  #
  def current_average_processing_time_in_seconds
    @current_average_processing_time_in_seconds ||= begin
      avg = PatientAssignment.
        select("avg(EXTRACT(EPOCH FROM (
          patient_assignments.checked_out_at - patients.created_at)))
          as average_time").
        joins(:patient).references(:patient).
        where('patient_assignments.checked_out_at
          is not null and patient_assignments.checked_out_at::Date =
          patients.created_at::Date and treatment_area_id = ?
          and patients.created_at::Date = ?', id, Date.today).
        group("treatment_area_id")

      avg[0].try(:average_time)
    end
  end

  # Uses both the current and base processing time averages to calculate a more
  # balanaced average processing time giving a slight weighted advantage to the
  # base time
  #
  def weighted_average_processing_time_in_seconds
    if base_processing_time_in_seconds.present? &&
       current_average_processing_time_in_seconds.present?
      (base_processing_time_in_seconds * 3) +
      (current_average_processing_time_in_seconds * 2) / 5
    else
      current_average_processing_time_in_seconds ||
      base_processing_time_in_seconds
    end
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
