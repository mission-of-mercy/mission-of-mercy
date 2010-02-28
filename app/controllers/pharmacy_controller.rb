class PharmacyController < ApplicationController
  def check_out
    @patient = Patient.find(params[:patient_id])
    
    @patient.patient_prescriptions.each do |p| 
      p.prescribed = true
    end
    
    Prescription.all.each do |pres|
      unless @patient.prescriptions.exists? pres
        @patient.patient_prescriptions.build(:prescription_id => pres.id)
      end
    end
  end

  def check_out_complete
    @patient = Patient.find(params[:patient_id])
    
    @patient.attributes = params[:patient]
    
    @patient.patient_prescriptions.each do |p|
      p.destroy if !p.new_record? && p.prescribed == "0"
    end
    
    @patient.save
    
    @patient.flows.create(:area_id => ClinicArea::PHARMACY)
    
    flash[:notice] = "Patient successfully checked out"
    
    redirect_to patients_path
  end

end
