class Admin::ReportsController < ApplicationController
  before_filter :admin_required
  
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
    @areas   = TreatmentArea.all(:order => "name")
    @current_capacity = @areas.map {|a| [a.name, a.patients.count || 0] }
  end
  
  def post_clinic
    @report = Reports::PostClinic.new
  end

end
