class ReportsController < ApplicationController
  before_filter :admin_required
  
  def index
  
  end
  
  def clinic_summary
    if params[:day] && params[:span]
      @report = Reports::ClinicSummary.new(params[:day], params[:span])
    else
      @report = Reports::ClinicSummary.new
    end
    
    ## Graph
    @areas   = TreatementArea.all(:order => "name")
    @current_capacity = @areas.map {|a| [a.name, a.patients.count] }
  end

  def movement_summary  
    @check_in_count = Patient.count('id',:conditions => ["exported_to_dexis is null AND check_out is null AND check_in > ? and check_in < ?",Time.today, Time.today + 1.day])
    @xray_count = Patient.count('id',:conditions => ["exported_to_dexis is not null AND check_out is null AND check_in > ? and check_in < ?",Time.today, Time.today + 1.day])
    @check_out_count = Patient.count('id',:conditions => ["check_out is not null AND check_in > ? and check_in < ?",Time.today, Time.today + 1.day])
    
    @check_in_to_xray_average = 0
    
    patients = Patient.find(:all,:conditions => ["exported_to_dexis is not null AND check_in > ? and check_in < ?",Time.today, Time.today + 1.day])
    patients.each do |p|
      @check_in_to_xray_average += ((p.exported_to_dexis - p.check_in) / 60).to_i
    end
    
    @check_in_to_xray_average = patients.length > 0 ? (@check_in_to_xray_average / patients.length) : 0
    
    @check_in_to_check_out_average = 0
    
    patients = Patient.find(:all,:conditions => ["check_out is not null AND check_in > ? and check_in < ?",Time.today, Time.today + 1.day])
    patients.each do |p|
      @check_in_to_check_out_average += ((p.check_out - p.check_in) / 60).to_i
    end
    
    @check_in_to_check_out_average = patients.length > 0 ? (@check_in_to_check_out_average / patients.length) : 0
    
    @xray_to_check_out_average = 0
    
    patients = Patient.find(:all,:conditions => ["exported_to_dexis is not null AND check_out is not null AND check_in > ? and check_in < ?",Time.today, Time.today + 1.day])
    patients.each do |p|
      @xray_to_check_out_average += ((p.check_out - p.exported_to_dexis) / 60).to_i
    end
    
    @xray_to_check_out_average = patients.length > 0 ? (@xray_to_check_out_average / patients.length) : 0
  end

end
