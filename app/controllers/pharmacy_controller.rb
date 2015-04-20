class PharmacyController < ApplicationController
  include CanHasPharmacy

  before_filter :authenticate_user!
  before_filter :find_patient, :only => [:check_out, :check_out_complete]

  def index
    @patients_table = PatientsTable.new
    @patient_search = @patients_table.search(params)
  end

  def check_out
    prescriptions
  end

  def check_out_complete
    pharmacy_check_out

    flash[:notice] = "Prescriptions sucessfully added to patient's record"
    redirect_to pharmacy_path
  end

  private

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
