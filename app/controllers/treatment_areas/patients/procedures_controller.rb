class TreatmentAreas::Patients::ProceduresController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_treatment_area
  before_filter :find_patient

  def index
    @patient_procedure = @patient.patient_procedures.build

    @patient.patient_prescriptions.each do |p|
      p.prescribed = true
    end

    Prescription.all.each do |pres|
      unless @patient.prescriptions.exists? pres
        @patient.patient_prescriptions.build(:prescription_id => pres.id)
      end
    end

    @procedure_added = params.has_key?(:procedure_added)
  end

  def create
    if tooth_numbers = params[:patient_procedure].delete(:tooth_numbers)
      tooth_numbers.each do |tooth|
        PatientProcedure.create(params[:patient_procedure].
          merge(tooth_number: tooth))

        stats.procedure_added
      end

      @patient_procedure = @patient.patient_procedures.build

      redirect_to treatment_area_patient_procedures_path(:procedure_added => true)
    else
      @patient_procedure = PatientProcedure.new(params[:patient_procedure])

      if @patient_procedure.save

        stats.procedure_added

        @patient_procedure = @patient.patient_procedures.build

        redirect_to treatment_area_patient_procedures_path(:procedure_added => true)
      else
        @selected_procedure = params[:patient_procedure][:procedure_id]

        render :action => :index
      end
    end
  end

  private

  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
