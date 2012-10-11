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
    tooth_numbers = params[:patient_procedure].delete(:tooth_number)
    teeth = list_to_array(tooth_numbers)

    procedures  = add_multiple_procedures(params[:patient_procedure], teeth)
    mark_procedures_as_added(procedures)

    if procedures.empty?
      @patient_procedure = PatientProcedure.new(params[:patient_procedure].
                                            merge(:tooth_number => tooth_numbers))
      @patient_procedure.valid?
      @selected_procedure = params[:patient_procedure][:procedure_id]
      params[:patient_procedure][:tooth_number] = tooth_numbers
      render :action => :index
    else
      redirect_to treatment_area_patient_procedures_path(:procedure_added => true)
    end
  end

  private

  def list_to_array(comma_list)
    comma_list.split(/\s*,\s*/)
  end

  def add_multiple_procedures(procedure_params, teeth)
    teeth = [nil] if teeth.empty? # ensure we create at least one
    PatientProcedure.transaction do
      teeth.map do |tooth_number|
        procedure_params[:tooth_number] = tooth_number
        PatientProcedure.create!(procedure_params)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    []
  end

  def mark_procedures_as_added(procedures)
    procedures.length.times  { stats.procedure_added }
  end

  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
