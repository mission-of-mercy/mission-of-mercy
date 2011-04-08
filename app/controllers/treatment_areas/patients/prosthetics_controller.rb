module TreatmentAreas::Patients
  class ProstheticsController < Base

    def index
      @patient.prosthetic ||= Prosthetic.new
    end
  
    def create
      @patient.update_attributes(params[:patient])
      
      redirect_to treatment_area_patient_prescriptions_path
    end
  end
end