class TreatmentAreasController < ApplicationController
  before_filter :authenticate_user!

  def change
    base =  "/treatment_areas"
    base += "/patients" unless params[:current_controller] == "patients"

    options = {
                :controller        => "#{base}/#{params[:current_controller]}",
                :action            => params[:current_action],
                :treatment_area_id => params[:treatment_area_id]
              }

    options[:patient_id]   = params[:patient_id] unless params[:patient_id].blank?
    options[:chart_number] = params[:current_chart] unless params[:current_chart].blank?

    redirect_to options
  end
end
