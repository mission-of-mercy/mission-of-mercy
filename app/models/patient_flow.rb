class PatientFlow < ActiveRecord::Base
  require 'time_scope'
  extend TimeScope

  belongs_to :patient
  belongs_to :treatment_area

  def area
    ClinicArea[area_id]
  end
end
