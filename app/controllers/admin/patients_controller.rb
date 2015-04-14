class Admin::PatientsController < ApplicationController
  before_filter :admin_required, :set_current_tab
  before_filter :find_patient, :only => [:edit, :update, :destroy]

  def index
    @patients_table = PatientsTable.new(:chart_number, :name,  :age,
      :treatment_area_id, :procedure_id, :count
    )
    @patient_search = @patients_table.search(params)
  end

  def edit
    @patient = @patient.decorate
    @patient.build_previous_mom_clinics
  end

  def update
    if @patient.update_attributes(patient_params)
      flash[:notice] = 'Patient was successfully updated.'

      redirect_to admin_patients_path
    else
      @patient = @patient.decorate
      render :action => "edit"
    end
  end

  def destroy
    @patient.destroy

    flash[:notice] = "Chart ##{@patient.id} successfully destroyed"

    redirect_to admin_patients_path
  end

  private

  def find_patient
    @patient = Patient.find(params[:id])
  end

  def set_current_tab
    @current_tab = 'patients'
  end

  def patient_params
    params.require(:patient).permit!
  end
end
