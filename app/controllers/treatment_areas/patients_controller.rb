class TreatmentAreas::PatientsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_treatment_area
  
  def index
    if params[:commit] == "Clear"
      params[:chart_number] = ""
      params[:name] = ""
    end
  
    @patients = Patient.search(params[:chart_number],params[:name],params[:page])

    respond_to do |format|
      format.html
    end
  end

  private
  
  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end
end