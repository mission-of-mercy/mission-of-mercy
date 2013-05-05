class SurveysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_patient
  before_filter :set_tab
  before_filter :find_survey, only: [:edit, :update]

  def new
    @survey = Survey.new
  end

  def create
    @patient.survey = Survey.new(params[:survey])

    if @patient.save
      route_request
    else
      render :new
    end
  end

 def update
    if @survey.update_attributes(params[:survey])
      route_request
    else
      render :edit
    end
  end

  private

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end

  def find_survey
    @survey = Survey.find(params[:id])
  end

  def set_tab
    @current_tab = "new"
  end

  def route_request
    if params[:commit] == "Back"
      redirect_to edit_patient_path(@patient)
    else
      stats.patient_checked_in
      redirect_to new_patient_path(last_patient_id:  @patient.id)
    end
  end
end
