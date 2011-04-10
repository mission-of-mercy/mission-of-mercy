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
    @areas            = TreatmentArea.all(:order => "name")
    
    @current_capacity = @areas.map do |a|
      count = a.patients.count || 0
      count = Patient.count(:conditions => {:radiology => true}) if a.radiology?
      [a.name, count]
    end
  end
  
  def post_clinic
    @report = Reports::PostClinic.new
  end
  
  def set_current_tab
    @current_tab = "reports"
  end

end
