class TreatmentAreas::PatientsController < CheckoutController
  before_filter :authenticate_user!

  def index
    @patients_table = PatientsTable.new
    @patient_search = @patients_table.search(params)
  end

  def radiology
    @patient = Patient.find(params[:id])

    if dexis? || kodak?
      path = [ENV['XRAY_PATH'], "passtodex",
              current_user.x_ray_station_id, ".dat"].join

      @patient.export_to_dexis(File.expand_path(path))
    end

    respond_to do |format|
      format.html do
        @patient.check_out(TreatmentArea.radiology)

        redirect_to treatment_area_patient_procedures_path(TreatmentArea.radiology,
                                                           @patient.id)
      end
    end
  rescue => e
    flash[:error] = e.message
    redirect_to :action => :index
  end
end
