class TreatmentAreas::Patients::Base < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_treatment_area
  before_filter :find_patient

  private

  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
