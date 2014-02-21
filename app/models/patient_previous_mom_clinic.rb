class PatientPreviousMomClinic < ActiveRecord::Base
  after_save :destroy_unless_attended

  belongs_to :patient

  def description
    if clinic_year
      [clinic_year, location].join(" ")
    else
      location
    end
  end

  private

  def destroy_unless_attended
    destroy unless attended
  end
end
