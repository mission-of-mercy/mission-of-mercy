class PatientAssignment < ActiveRecord::Base

  belongs_to :patient
  belongs_to :treatment_area

  def check_out
    self[:checked_out_at] = Time.now
    save
  end

end
