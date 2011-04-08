class TreatmentAreas::PatientsController < ApplicationController
  before_filter :login_required
  before_filter :find_treatment_area
  
  def index
    if params[:commit] == "Clear"
      params[:chart_number] = ""
      params[:name] = ""
    end
  
    @patients = Patient.search(params[:chart_number],params[:name],params[:page])

    respond_to do |format|
      format.html
    end
  end
  
  def prosthetics_export
    csv_string = FasterCSV.generate do |csv|
      Prosthetic.all.each do |prosthetic|
        csv << [ prosthetic.patient.id, prosthetic.patient.full_name, 
                 prosthetic.patient.phone, prosthetic.pickup, prosthetic.notes]
      end
    end
    
    send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
              :disposition => "attachment; filename=prosthetics.csv"
  end

  private
  
  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
  end
end