class AssignmentDeskController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @patient = Patient.find(params[:id])
    @areas   = TreatmentArea.all(:order => "name")
    @current_capacity = TreatmentArea.current_capacity
  end

  def update
    patient = Patient.find(params[:id])
    patient.update_attributes({ radiology: params[:patient][:radiology] })
    check_in(patient)

    flash[:notice] = 'Patient was successfully assigned.'

    redirect_to patients_path
  end

  private

  def check_in(patient)
    area_id = params[:patient][:assigned_to]
    if area_id
      area = TreatmentArea.find(area_id)
      patient.check_in(area)
    end
  end
end
