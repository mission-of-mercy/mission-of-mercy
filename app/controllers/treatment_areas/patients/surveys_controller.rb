class TreatmentAreas::Patients::SurveysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_treatment_area
  before_filter :find_patient

  def edit
    @survey = @patient.survey

    @patient.patient_pre_meds.each do |p|
      p.prescribed = true
    end

    PreMed.all.each do |med|
      unless @patient.pre_meds.exists? med
        @patient.patient_pre_meds.build(:pre_med_id => med.id)
      end
    end
  end

  def update
    @patient.update_attributes(params[:patient])

    if @patient.survey
      if @patient.survey.update_attributes(params[:survey])
        redirect_to treatment_area_patient_procedures_path(@treatment_area, @patient)
      else
        render :action => "edit"
      end
    else
      redirect_to treatment_area_patient_procedures_path(@treatment_area, @patient)
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
