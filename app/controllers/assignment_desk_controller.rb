class AssignmentDeskController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @patient = Patient.find(params[:id])
    @areas   = TreatmentArea.all(:order => "name")
    @current_capacity = TreatmentArea.current_capacity
  end

  def update
    patient = Patient.find(params[:id])
    patient.assign(params[:patient][:assigned_to], params[:patient][:radiology])

    flash[:notice] = 'Patient was successfully assigned.'
    redirect_to patients_path
  end

end
