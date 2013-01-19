module Admin
  class PatientsController < ApplicationController

    before_filter :admin_required, :set_current_tab

    def index
      @patients = Patient.search(params)
    end

    def edit
      @patient = PatientDecorator.find(params[:id])
      @patient.build_previous_mom_clinics
    end

    def update
      if params[:id] == nil
        params[:id] = params[:patient_id]
      end

      @patient = Patient.find(params[:id])

      if @patient.update_attributes(params[:patient])
        flash[:notice] = 'Patient was successfully updated.'

        redirect_to admin_patients_path
      else
        @patient = PatientDecorator.new(@patient)
        render :action => "edit"
      end
    end

    def destroy
      @patient = Patient.find(params[:id])
      @patient.destroy

      redirect_to admin_patients_path
    end

    def history
      @patient = Patient.find(params[:patient_id])
    end

    private

    def set_current_tab
      @current_tab = 'patients'
    end

  end
end
