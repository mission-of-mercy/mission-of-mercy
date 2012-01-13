module Admin
  class PatientAssignmentsController < ApplicationController

    before_filter :admin_required, :set_current_tab

    def show
      @patient = Patient.find(params[:patient_id])
    end

    private

    def set_current_tab
      @current_tab = 'patients'
    end

  end
end
