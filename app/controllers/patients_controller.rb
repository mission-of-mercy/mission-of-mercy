class PatientsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :lookup_zip, :lookup_city ]
  before_filter :save_date_input
  before_filter :find_patient,       :only => [:new, :create, :edit, :update]

  def create
    if @registration.create!
      if @patient.previous_chart_number.present?
        stats.patient_checked_in
        redirect_to new_patient_path(last_patient_id:  @patient.id)
      elsif @patient.survey
        redirect_to edit_patient_survey_path(@patient, @patient.survey)
      else
        redirect_to new_patient_survey_path(@patient)
      end
    else
      render :action => "new"
    end
  end

  def update
    if @registration.save!
      redirect_to edit_patient_survey_path(@patient, @patient.survey)
    else
      render :action => "edit"
    end
  end

  def chart
    @patient = Patient.find_by_id(params[:id])

    if @patient
      respond_to do |format|
        format.html do
          @patient.update_attributes(chart_printed: true)
          render :layout => "print"
        end
        format.pdf do
          @patient.update_attributes(chart_printed: true)
          pdf = PatientChart.new(@patient)
          send_data pdf.render, filename: "chart_#{@patient.id}.pdf",
                                type: "application/pdf",
                                disposition: "inline"
        end
        format.js do
          if PrintChart.printers.include? session[:printer]
            Resque.enqueue(PrintChart, @patient.id, session[:printer])
            @queued = true
          else
            @queued = false
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Could not find patient with id=#{params[:id]}')
    end
  end

  def reprint
    if params[:patient_search].blank?
      params[:patient_search] = { chart_printed: false }
    end
    @current_tab = "reprint"
    @patients_table = PatientsTable.new
    @patient_search = @patients_table.search(params)
  end

  def previous
    @current_tab = "previous"
    @patients_table = PatientsTable.new(:chart_number, :name)
    @patient_search = @patients_table.search(params)
  end

  private

  def save_date_input
    if params[:date_input]
      session[:date_input] = params[:date_input]
    else
      params[:date_input] = session[:date_input]
    end
  end

  def find_patient
    @current_tab  = "new"
    patient       = Patient.find(params[:id]) if params[:id]
    @registration = Registration.new(params: params, patient: patient)
    @patient      = @registration.decorated_patient
  end

end
