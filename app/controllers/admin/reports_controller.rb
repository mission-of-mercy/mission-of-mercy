require 'csv'

class Admin::ReportsController < ApplicationController
  before_filter :admin_or_reports_required
  before_filter :set_current_tab
  before_filter :admin_required, only: :export

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

  def admin_or_reports_required
    if !signed_in? ||
      ![UserType::ADMIN, UserType::REPORTS].include?(current_user.user_type)
      access_denied
    end
  end
end
