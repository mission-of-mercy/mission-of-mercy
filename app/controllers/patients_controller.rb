class PatientsController < ApplicationController

  before_filter :authenticate_user!, :except => [ :lookup_zip, :lookup_city ]
  before_filter :date_input
  before_filter :find_last_patient, :only => [:new]

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
    @patient.build_previous_mom_clinics
  end

  def print
    @patient = Patient.find_by_id(params[:id])

    if @patient
      render :action => "print", :layout => "print"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def show
    @patient = Patient.find_by_id(params[:id])

    respond_to do |format|
      format.json do
        attributes = @patient.try(:attributes)
        attributes[:date_of_birth] = @patient.dob if @patient

        render :json => { :patient => attributes }.to_json
      end
    end
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

      @patient.build_previous_mom_clinics

      render :action => "new"
    end
  end

  def radiology
    @patient = Patient.find(params[:patient_id])

    if dexis?
      app_config["dexis_paths"].each do |root_path|
        path = [root_path, "passtodex", current_user.x_ray_station_id, ".dat"].join

        @patient.export_to_dexis(path)
      end
    end

    respond_to do |format|
      format.html do
        @patient.check_out(TreatmentArea.radiology)

        redirect_to treatment_area_patient_procedures_path(TreatmentArea.radiology, @patient.id)
      end
    end
  rescue => e
    flash[:error] = e.message
    redirect_to patients_path
  end

  private

  def add_procedures_to_patient(patient)
    procedures = Procedure.find(:all, :conditions => {:auto_add => true})

    procedures.each do |p|
      patient.patient_procedures.build(:procedure_id => p.id)
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

end
