class PatientFlow < ActiveRecord::Base
  extend TimeScope

  belongs_to :patient
  belongs_to :treatment_area

  def area
    ClinicArea[area_id]
  end
end
