class TreatmentAreasController < ApplicationController
  before_filter :authenticate_user!

  def index
    @treatment_areas = TreatmentArea.order("name")
  end

  # TODO Clean this up
  def change
    base =  "TreatmentAreas"
    base += "::Patients" unless params[:current_controller] == "patients"

    options = {
                :controller        => "#{base}::#{params[:current_controller].capitalize}",
                :action            => params[:current_action],
                :treatment_area_id => params[:treatment_area_id]
              }

    options[:patient_id]   = params[:patient_id]    unless params[:patient_id].blank?
    options[:chart_number] = params[:current_chart] unless params[:current_chart].blank?

    redirect_to options
  end
end
