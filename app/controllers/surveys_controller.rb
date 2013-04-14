class SurveysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_patient
  before_filter :set_tab

  def new
    @survey = Survey.new
  end

  def create
    @patient.survey = Survey.new(params[:survey])

    if @patient.save
      stats.patient_checked_in
      redirect_to new_patient_path(last_patient_id:  @patient.id)
    else
      render :new
    end
  end

  private

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_tab
    @current_tab = "new"
  end
end
