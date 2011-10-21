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

    @prescriptions = @patient.patient_prescriptions.sort_by {|p| p.prescription.position || -1 }
  end

  def check_out_complete
    @patient = Patient.find(params[:patient_id])

    @patient.attributes = params[:patient]

    @patient.patient_prescriptions.each do |p|
      p.destroy if !p.new_record? && p.prescribed == "0"
    end

    @patient.save

    if @patient.patient_prescriptions.count > 0
      @patient.flows.create(:area_id => ClinicArea::PHARMACY)
    end

    flash[:notice] = "Prescriptions sucessfully added to patient's record"
    redirect_to patients_path
  end

end
