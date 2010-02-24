class TreatementAreasController < ApplicationController
  before_filter :admin_required, :except => [:check_out, :check_out_post]
  before_filter :login_required
  
  def index
    @areas = TreatementArea.all
  end

  def new
    @treatement_area = TreatementArea.new
  end
  
  def create
    @treatement_area = TreatementArea.new(params[:treatement_area])
    
    if @treatement_area.save
      redirect_to treatement_areas_path
    else
      render :action => :new
    end
  end

  def edit
    @treatement_area = TreatementArea.find(params[:id])
  end
  
  def update
    @treatement_area = TreatementArea.find(params[:id])

    if @treatement_area.update_attributes(params[:treatement_area])
      flash[:notice] = 'Treatment Area was successfully updated.'
      redirect_to treatement_areas_path
    else
      render :action => "edit" 
    end
  end

  def show
    @treatement_area = TreatementArea.find(params[:id])
  end
  
  def check_out
    @treatement_area = TreatementArea.find(params[:id])
    @patient         = Patient.find(params[:patient_id])
    @patient_procedure = @patient.patient_procedures.build
  end

  def check_out_post
    @treatement_area   = TreatementArea.find(params[:id])
    @patient           = Patient.find(params[:patient_id])
    
    @patient_procedure = PatientProcedure.new(params[:patient_procedure])
    
    if @patient_procedure.save
      flash[:last_provider_id] = @patient_procedure.provider_id
      
      @patient_procedure = @patient.patient_procedures.build
      
      render :action => :check_out
    else
      render :action => :check_out
    end
  end
end
