class TreatmentAreas::PatientsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_treatment_area

  def index
    @patients_table = PatientsTable.new
    @patient_search = @patients_table.search(params)
  end

  def radiology
    @patient = Patient.find(params[:id])

    if dexis? || kodak?
      app_config["dexis_paths"].each do |root_path|
        path = [root_path, "passtodex", current_user.x_ray_station_id, ".dat"].join

        @patient.export_to_dexis(path)
      end
    end

    respond_to do |format|
      format.html do
        @patient.check_out(TreatmentArea.radiology)

        redirect_to treatment_area_patient_procedures_path(TreatmentArea.radiology, @patient.id)
      end
    end
  rescue => e
    flash[:error] = e.message
    redirect_to :action => :index
  end

  private

  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end
end
