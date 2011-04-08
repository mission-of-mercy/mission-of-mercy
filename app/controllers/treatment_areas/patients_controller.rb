class TreatmentAreas::PatientsController < ApplicationController
  before_filter :login_required
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
  
  def prosthetics_export
    
  end

  private
  
  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end
end