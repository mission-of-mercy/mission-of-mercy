class TreatmentAreas::PatientsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_treatment_area

  def index
    @patients = Patient.search(params)
  end

  private

  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end
end
