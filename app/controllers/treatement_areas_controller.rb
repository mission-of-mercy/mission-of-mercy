class TreatementAreasController < ApplicationController
  before_filter :admin_required, :except => [:assign, :assign_complete, :check_out, :check_out_post, :pre_check_out, :pre_check_out_post, :check_out_completed]
  before_filter :login_required
  before_filter :setup_procedures, :only => [:new, :edit]
  
  def index
    @areas = TreatementArea.all
  end

  def new

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

  end
  
  def update
    @treatement_area = TreatementArea.find(params[:id])
    
    @treatement_area.attributes = params[:treatement_area]
    
    @treatement_area.procedure_treatment_area_mappings.each do |p|
      p.destroy if !p.new_record? && p.assigned == "0"
    end

    if @treatement_area.save
      flash[:notice] = 'Treatment Area was successfully updated.'
      redirect_to treatement_areas_path
    else
      render :action => "edit" 
    end
  end

  def show
    @treatement_area = TreatementArea.find(params[:id])
  end
  
  def assign
    @patient = Patient.find(params[:patient_id])
    @areas   = TreatementArea.all(:order => "name")
    
    @current_capacity = @areas.map {|a| [a.name, a.patients.count || 0] }
  end
  
  def assign_complete
    patient = Patient.find(params[:patient_id])
    
    patient.update_attributes(params[:patient])
    
    flash[:notice] = 'Patient was successfully assigned.'
    redirect_to patients_path
  end
  
  def check_out
    @treatement_area = TreatementArea.find(params[:treatement_area_id])
    @patient         = Patient.find(params[:patient_id])
    @patient_procedure = @patient.patient_procedures.build
  end

  def check_out_post
    @treatement_area   = TreatementArea.find(params[:treatement_area_id])
    @patient           = Patient.find(params[:patient_id])
    
    @patient_procedure = PatientProcedure.new(params[:patient_procedure])
    
    if @patient_procedure.save
      flash[:last_provider_id] = @patient_procedure.provider_id
      flash[:procedure_added] = true
      
      @patient_procedure = @patient.patient_procedures.build
      
      redirect_to treatement_area_checkout_path(@treatement_area, @patient)
    else
      render :action => :check_out
    end
  end
  
  def pre_check_out
    @treatement_area = TreatementArea.find(params[:treatement_area_id])
    @patient         = Patient.find(params[:patient_id])
    @survey          = @patient.survey
    
    @patient.patient_pre_meds.each do |p| 
      p.prescribed = true
    end
    
    PreMed.all.each do |med|
      unless @patient.pre_meds.exists? med
        @patient.patient_pre_meds.build(:pre_med_id => med.id)
      end
    end
  end
  
  def pre_check_out_post
    @treatement_area = TreatementArea.find(params[:treatement_area_id])
    @patient         = Patient.find(params[:patient_id])
    
    @patient.attributes = params[:patient]
    
    @patient.patient_pre_meds.each do |p|
      p.destroy if !p.new_record? && p.prescribed == "0"
    end
    
    @patient.save
    
    if @patient.survey.update_attributes(params[:survey])
      redirect_to treatement_area_checkout_path(@treatement_area, @patient)
    else
      render :action => pre_check_out
    end
  end
  
  def check_out_completed
    area    = TreatementArea.find(params[:treatement_area_id])
    patient = Patient.find(params[:patient_id])
    
    if area.id != 1
      patient.flows.create(:area_id => ClinicArea::CHECKOUT,
                           :treatement_area_id => area.id)
    end
                         
    if patient.assigned_treatment_area_id == area.id
      patient.update_attribute(:assigned_treatment_area_id, nil)
    end
    
    patient.update_attribute(:survey_id, nil) if area.id != 1
    
    flash[:notice] = "Patient successfully checked out"
                          
    redirect_to patients_path(:treatement_area_id => area.id)
  end
  
  private
  
  def setup_procedures
    if params[:id]
      @treatement_area = TreatementArea.find(params[:id])
    else
      @treatement_area = TreatementArea.new
    end
    
    @treatement_area.procedure_treatment_area_mappings.each do |p| 
      p.assigned = true
    end
    
    Procedure.all.each do |pro|
      unless @treatement_area.procedures.exists? pro
        @treatement_area.procedure_treatment_area_mappings.build(:procedure_id => pro.id)
      end
    end
  end
end
