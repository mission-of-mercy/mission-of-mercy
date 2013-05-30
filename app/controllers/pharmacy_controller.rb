class PharmacyController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_patient, :only => [:check_out, :check_out_complete]

  def index
    @patients_table = PatientsTable.new
    @patient_search = @patients_table.search(params)
  end

  def check_out
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
    new_prescription = false

    @patient.attributes = params[:patient]

    @patient.patient_prescriptions.each do |p|
      new_prescription = true if p.new_record?
    end

    @patient.save

    if new_prescription
      @patient.flows.create(:area_id => ClinicArea::PHARMACY)
    end

    flash[:notice] = "Prescriptions sucessfully added to patient's record"
    redirect_to pharmacy_path
  end

  private

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
