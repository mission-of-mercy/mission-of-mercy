class AssignmentDeskController < ApplicationController
  before_filter :authenticate_user!

  def index
    @patients_table = PatientsTable.new
    @patient_search = @patients_table.search(params)
  end

  def edit
    @patient = Patient.find(params[:id])
    @is_assigned_to_radiology = @patient.assigned_to?(TreatmentArea.radiology)

    @areas = TreatmentArea.order('name')
    @assignments = TreatmentArea.current_capacity
    @capacity = @areas.map {|ta| [ta.name, ta.capacity] }
  end

  def update
    patient = Patient.find(params[:id])
    patient_params = params[:patient_params]

    if patient.assign(patient_params[:assigned_to], checked?(patient_params[:radiology]))
      flash[:notice] = 'Patient was successfully assigned.'
    end

    redirect_to :action => "index"
  end

  private

  def checked?(checkbox_value)
    checkbox_value != '0'
  end

end
