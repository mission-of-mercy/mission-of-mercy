class PatientsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only => [ :edit, :destroy ]
  
  def index
    if params[:commit] == "Clear"
      params[:chart_number] = ""
      params[:name] = ""
    end
  
    @patients = Patient.search(params[:chart_number],params[:name],params[:page])

    @area = params[:treatment_area_id]
    @area ||= session[:treatment_area_id] if session[:treatment_area_id]

    respond_to do |format|
      format.html # index.html.erb
      format.js { render :layout => false }
    end
  end

  def new
    @patient = Patient.new
    @patient.survey = Survey.new

    @patient.state = app_config["state"]
    
    if flash[:last_patient_id] != nil
      @last_patient = Patient.find(flash[:last_patient_id])
    end
  end

  def edit
    @patient = Patient.find(params[:id])
  end
  
  def check_out
    @patient = Patient.find(params[:id])

    if @patient.check_out == nil
      @patient.check_out = DateTime.now
    end
  end
  
  def print
    @patient = Patient.find(params[:id])

    render :action => "print", :layout => "print"
  end

  def create
    @patient = Patient.new(params[:patient])
    
    add_procedures_to_patient(@patient)
    
    #Capitalize First and Last Names
    @patient.first_name = @patient.first_name.capitalize
    @patient.last_name = @patient.last_name.capitalize
    
    # Calculate Travel Time
    if params[:patient_travel_time_minutes].length > 0 && params[:patient_travel_time_minutes].match(/^\d+$/) != nil
      @patient.travel_time = params[:patient_travel_time_minutes].to_i
    end
    
    if params[:patient_travel_time_hours].length > 0 && params[:patient_travel_time_hours].match(/^\d+$/) != nil
      @patient.travel_time = 0 if @patient.travel_time.nil?
      @patient.travel_time += params[:patient_travel_time_hours].to_i * 60
    end
    
    if @patient.save      
      flash[:last_patient_id] = @patient.id
      
      redirect_to new_patient_path
    else
      flash[:patient_travel_time_minutes] = params[:patient_travel_time_minutes]
      flash[:patient_travel_time_hours] = params[:patient_travel_time_hours]
    
      render :action => "new"
    end
  end
  
  def export_to_dexis_file
    @patient = Patient.find(params[:patient_id])
    
    path = [app_config["dexis_path"],"passtodex",current_user.x_ray_station_id.to_s,".dat"].join()
    
    @patient.export_to_dexis(path)
    
    respond_to do |format|
      format.html do 
        @patient.flows.create(:area_id => ClinicArea::XRAY)
        
        redirect_to treatment_area_checkout_path(:treatment_area_id => 1, :patient_id => @patient.id)
      end
      format.js
    end
  end

  def update
    if params[:id] == nil
      params[:id] = params[:patient_id]
    end
    
    @patient = Patient.find(params[:id])
    
    if @patient.update_attributes(params[:patient])
      if params[:commit] == "Next"
        redirect_to(:controller => 'exit_surveys', :action => 'new', :id => @patient.id)
      else
        flash[:notice] = 'Patient was successfully updated.'
        
        redirect_to patients_path
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    redirect_to(patients_url)
  end
  
  protected
  
  def add_procedures_to_patient(patient)
    procedures = Procedure.find(:all, :conditions => {:auto_add => true})
    
    procedures.each do |p|
      patient.patient_procedures.build(:procedure_id => p.id)
    end
  end
end
