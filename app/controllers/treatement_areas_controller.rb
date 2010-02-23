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
    
    #@treatement_area.procedures.each do |p|
    #  @patient.patient_procedures.build(:procedure_id => p.id)
    #end
  end

  def check_out_post
    @treatement_area = TreatementArea.find(params[:id])
    @patient         = Patient.find(params[:patient_id])
    
    if @patient.update_attributes(params[:patient])
      flash[:notice] = "Patient Successfully Checked Out"
      redirect_to patients_path(:treatement_area_id => @treatement_area.id)
    else
      render :action => :check_out
    end
  end
end
