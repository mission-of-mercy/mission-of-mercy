class PatientsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :lookup_zip, :lookup_city ]
  before_filter :admin_required, :only => [ :edit, :destroy, :history ]
  before_filter :date_input
  before_filter :find_last_patient, :only => [:new]
  before_filter :set_current_tab

  def index
    if params[:commit] == "Clear"
      params[:chart_number] = nil
      params[:name] = nil
    end

    @patients = Patient.search(params[:chart_number], params[:name], params[:page])

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

    build_previous_mom_clinics
  end

  def edit
    @patient = Patient.find(params[:id])

    build_previous_mom_clinics
  end

  def print
    @patient = Patient.find(params[:id])

    render :action => "print", :layout => "print"
  end

  def create
    @patient = Patient.new(params[:patient])

    add_procedures_to_patient(@patient)

    if @patient.errors.empty? && @patient.save
      stats.patient_checked_in
      redirect_to new_patient_path(:last_patient_id =>  @patient.id)
    else
      @patient_travel_time_minutes = params[:patient_travel_time_minutes]
      @patient_travel_time_hours   = params[:patient_travel_time_hours]

      build_previous_mom_clinics

      render :action => "new"
    end
  end

  def export_to_dexis_file
    @patient = Patient.find(params[:patient_id])

    app_config["dexis_paths"].each do |root_path|
      path = [root_path, "passtodex", current_user.x_ray_station_id, ".dat"].join()

      @patient.export_to_dexis(path)
    end

    respond_to do |format|
      format.html do
        @patient.flows.create(:area_id => ClinicArea::XRAY)
        @patient.check_out(TreatmentArea.radiology)

        redirect_to treatment_area_patient_procedures_path(TreatmentArea.radiology, @patient.id)
      end
    end
  rescue => e
    flash[:error] = e.message
    redirect_to patients_path
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

  def history
    @patient = Patient.find(params[:patient_id])
  end

  private

  def add_procedures_to_patient(patient)
    procedures = Procedure.find(:all, :conditions => {:auto_add => true})

    procedures.each do |p|
      patient.patient_procedures.build(:procedure_id => p.id)
    end
  end

  def build_previous_mom_clinics
    PatientPreviousMomClinic::CLINICS.each do |y, l|
      existing = @patient.previous_mom_clinics.detect do |c|
          c.clinic_year == y && c.location == l
        end

      unless existing
        @patient.previous_mom_clinics.build(:clinic_year => y, :location => l)
      end
    end

  end

  def date_input
    if params[:date_input]
      session[:date_input] = params[:date_input]
    end

    @date_input = session[:date_input] || 'select'
  end

  def find_last_patient
    if params[:last_patient_id] != nil
      @last_patient = Patient.find(params[:last_patient_id])
    end
  end

  def set_current_tab
    @current_tab = "patients" if current_user.user_type == UserType::ADMIN
  end
end
