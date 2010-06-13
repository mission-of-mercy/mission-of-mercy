class AssignmentDeskController < ApplicationController
  before_filter :login_required
  
  def edit
    @patient = Patient.find(params[:id])
    @areas   = TreatmentArea.all(:order => "name")
    
    @current_capacity = @areas.map {|a| [a.name, a.patients.count || 0] }
  end
  
  def update
    patient = Patient.find(params[:id])
    
    patient.update_attributes(params[:patient])
    
    flash[:notice] = 'Patient was successfully assigned.'
    
    redirect_to patients_path
  end
end
