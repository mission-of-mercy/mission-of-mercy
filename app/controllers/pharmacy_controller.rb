class PharmacyController < ApplicationController
  before_filter :login_required
    
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
    
    @patient.check_out(session[:treatment_area_id]) unless session[:treatment_area_id].nil?
    
    @patient.save
    
    if (@patient.patient_prescriptions.count > 0 and !session[:treatment_area_id].nil?) or session[:treatment_area_id].nil?
      @patient.flows.create(:area_id => ClinicArea::PHARMACY) 
    end
    
    flash[:notice] = "Patient successfully checked out"
    
    if session[:treatment_area_id].nil?
      redirect_to patients_path
    else
      redirect_to patients_path(:treatment_area_id => session[:treatment_area_id])
    end
  end

end
