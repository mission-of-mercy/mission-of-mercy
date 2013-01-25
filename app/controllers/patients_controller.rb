class PatientsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :lookup_zip, :lookup_city ]
  before_filter :date_input
  before_filter :find_last_patient, :only => [:new]

  def new
    @current_tab    = "new"
    @registration   = Registration.new(params)
    @patient        = @registration.patient
    # TODO Move into Registration
    @patient.build_previous_mom_clinics
  end

  def create
    @current_tab  = "new"
    @registration = Registration.new(params)
    @patient      = @registration.patient

    # TODO Move into Registration
    add_procedures_to_patient(@patient)

    if @patient.errors.empty? && @patient.save
      stats.patient_checked_in
      redirect_to new_patient_path(:last_patient_id =>  @patient.id)
    else
      @patient.build_previous_mom_clinics

      render :action => "new"
    end
  end

  def chart
    @patient = Patient.find_by_id(params[:id])

    if @patient
      render :layout => "print"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def reprint
    @current_tab = "reprint"
    @patients = Patient.search(params)
  end

  def previous
    @current_tab = "previous"
    @patients = Patient.search(params)
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

    @date_input = session[:date_input] || 'text'
  end

  def find_last_patient
    if params[:last_patient_id] != nil
      @last_patient = Patient.find(params[:last_patient_id])
    end
  end

end
