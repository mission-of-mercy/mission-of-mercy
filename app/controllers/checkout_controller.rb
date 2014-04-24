class CheckoutController < ApplicationController
  before_filter :load_treatment_areas
  before_filter :find_treatment_area
  before_filter :find_patient

  private

  def load_treatment_areas
    @treatment_areas = TreatmentArea.check_out.order(:name)
  end

  private

  def find_treatment_area
    return unless params[:treatment_area_id]
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end

  def find_patient
    return unless params[:patient_id]
    @patient = Patient.find(params[:patient_id])
  end
end
