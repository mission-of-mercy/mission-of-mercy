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

  def export_patients
    if params[:patients]
      patients = Patient.find(params[:patients])
    else
      patients = Patient.all
    end

    csv_string = CSV.generate do |csv|
      csv << ["Chart #", "First Name", "Last Name", "Date of Birth", "Phone",
              "Street Address", "City", "State", "Zip", "Sex"]
      patients.sort_by(&:id).each do |patient|
        csv << [ patient.id, patient.first_name, patient.last_name,
                 patient.date_of_birth, patient.phone, patient.street,
                 patient.city, patient.state, patient.zip, patient.sex ]
      end
    end

    send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
              :disposition => "attachment; filename=#{params[:filename] || 'patients'}.csv"
  end

  private

  def set_current_tab
    @current_tab = "reports"
  end

end
