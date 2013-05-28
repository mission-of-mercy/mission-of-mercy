require 'csv'

class Admin::ReportsController < ApplicationController
  before_filter :admin_required
  before_filter :set_current_tab

  def index

  end

  def clinic_summary
    if params[:day] && params[:span]
      @report = Reports::ClinicSummary.new(params[:day], params[:span])
    else
      @report = Reports::ClinicSummary.new
    end
  end

  def treatment_area_distribution
    @areas               = TreatmentArea.order('name')
    @current_capacity    = TreatmentArea.current_capacity
    @areas_with_patients = TreatmentArea.with_patients
  end

  def post_clinic
    @report = Reports::PostClinic.new
  end

  def export
    @clinic_data = ClinicExporter.new.data

    respond_to do |format|
      format.xlsx
    end
  end

  private

  def set_current_tab
    @current_tab = "reports"
  end

end
