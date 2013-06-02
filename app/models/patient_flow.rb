class PatientFlow < ActiveRecord::Base
  belongs_to :patient
  belongs_to :treatment_area

  def area
    ClinicArea[area_id]
  end

  def area_humanized
    area.to_s.humanize
  end
end
