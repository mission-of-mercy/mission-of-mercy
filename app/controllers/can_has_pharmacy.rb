module CanHasPharmacy
  def prescriptions
    @patient.patient_prescriptions.each do |p|
      p.prescribed = true
    end

    Prescription.all.each do |pres|
      unless @patient.prescriptions.exists? pres
        @patient.patient_prescriptions.build(:prescription_id => pres.id)
      end
    end

    @prescriptions = @patient.patient_prescriptions.sort_by {|p| p.prescription.position || -1 }

  end

  def pharmacy_check_out
    new_prescription = false

    patient_params = params.require(:patient).permit(
      patient_prescriptions_attributes: %w[prescription_id prescribed id])

    @patient.attributes = patient_params

    @patient.patient_prescriptions.each do |p|
      new_prescription = true if p.new_record?
    end

    @patient.save

    if new_prescription
      @patient.flows.create(:area_id => ClinicArea::PHARMACY)
    end
  end
end
