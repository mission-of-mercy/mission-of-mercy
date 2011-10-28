class PatientPrescription < ActiveRecord::Base
  after_save :destroy_unless_prescribed

  belongs_to :patient
  belongs_to :prescription

  def full_description
    if prescription != nil
      prescription.full_description
    else
      "Prescription"
    end
  end

  private

  def destroy_unless_prescribed
    destroy unless prescribed
  end
end
