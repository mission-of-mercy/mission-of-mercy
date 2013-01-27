class PatientsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :lookup_zip, :lookup_city ]
  before_filter :save_date_input

  def new
    @current_tab    = "new"
    @registration   = Registration.new(params)
    @patient        = @registration.decorated_patient
  end

  def create
    @current_tab  = "new"
    @registration = Registration.new(params)
    @patient      = @registration.decorated_patient

    if @registration.create!
      stats.patient_checked_in
      redirect_to new_patient_path(last_patient_id:  @patient.id)
    else
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
    @patient_search = PatientsTable.new(:chart_number, :name).search(params)
  end

  private

  def save_date_input
    if params[:date_input]
      session[:date_input] = params[:date_input]
    else
      params[:date_input] = session[:date_input]
    end
  end

end
