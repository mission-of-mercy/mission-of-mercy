class PatientsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only => [ :edit, :destroy ]
  
  # GET /patients
  # GET /patients.xml
  def index
    if params[:commit] == "Clear"
      params[:chart_number] = ""
      params[:name] = ""
    end
  
    @patients = Patient.search(params[:chart_number],params[:name],params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.xml
  def show
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.xml
  def new
    @patient = Patient.new

    @patient.state = "CT"
    
    if flash[:last_patient_id] != nil
      @last_patient = Patient.find(flash[:last_patient_id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end
  
  # GET /patients/1/check_out
  def check_out
    @patient = Patient.find(params[:id])

    if @patient.check_out == nil
      @patient.check_out = DateTime.now
    end
  end
  
  # GET /patients/1/print
  def print
    @patient = Patient.find(params[:id])

    render :action => "print", :layout => "print"
  end

  # POST /patients
  # POST /patients.xml
  def create
    @patient = Patient.new(params[:patient])
    
    #@patient.check_in = DateTime.now
    
    #add_prescriptions_to_patient(@patient)
    
    #add_procedures_to_patient(@patient)
    
    if params[:race_other] != nil && @patient.race == "Other"
      @patient.race = params[:race_other]
    end
    
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
    
    respond_to do |format|
      if @patient.save
        
        flash[:last_patient_id] = @patient.id
        
        format.html { redirect_to(new_patient_path) }
        format.xml  { render :xml => @patient, :status => :created, :location => @patient }
      else
        flash[:patient_travel_time_minutes] = params[:patient_travel_time_minutes]
        flash[:patient_travel_time_hours] = params[:patient_travel_time_hours]
      
      
        format.html { render :action => "new" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def export_to_dexis_file
    @patient = Patient.find(params[:patient_id])
    
    testPath = "/Users/byron/Desktop/"
    livePath = "/srv/samba/share/"
    
    unless production?
      livePath = testPath
    end
    
    @path = [livePath,"passtodex",current_user.x_ray_station_id.to_s,".dat"].join()
    f = File.new(@path, "w")
    f.write(["PN=", @patient.id.to_s, "\r\n"].join())
    f.write(["LN=", @patient.last_name, "\r\n"].join())
    f.write(["FN=", @patient.first_name, "\r\n"].join())
    f.write(["BD=", @patient.date_of_birth_dexis, "\r\n"].join())
    f.write(["SX=", @patient.sex].join())
    f.close
    
    # Save Exported Time
    #@patient.exported_to_dexis = DateTime.now
    #w@patient.save
    
    respond_to do |format|
      format.js
    end
  end

  # PUT /patients/1
  # PUT /patients/1.xml
  def update
    if params[:id] == nil
      params[:id] = params[:patient_id]
    end
    
    @patient = Patient.find(params[:id])
    
    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        if params[:commit] == "Next"
          format.html { redirect_to(:controller => 'exit_surveys', :action => 'new', :id => @patient.id) }
        else
          flash[:notice] = 'Patient was successfully updated.'
          format.html { redirect_to(@patient) }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to(patients_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def add_prescriptions_to_patient(patient)
    prescriptions = Prescription.find(:all)
    
    prescriptions.each do |p|
      patient.patient_prescriptions.build(:prescription_id => p.id)
    end
  end
  
  def add_procedures_to_patient(patient)
    procedures = Procedure.find(:all, :conditions => {:auto_add => true})
    
    procedures.each do |p|
      patient.patient_procedures.build(:procedure_id => p.id, :provider => 'AUTOADD')
    end
  end
end
