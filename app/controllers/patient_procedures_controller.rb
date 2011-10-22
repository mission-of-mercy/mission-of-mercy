class PatientProceduresController < ApplicationController
  before_filter :authenticate_user!
  
  def destroy
    @patient_procedure = PatientProcedure.find(params[:id])
    @patient_procedure.destroy

    respond_to do |format|
    	format.js
    end
  end
end
