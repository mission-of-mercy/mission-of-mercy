require 'digest/md5'

class DashboardController < ApplicationController
  before_filter :authenticate

  def patients
    today     = Patient.where("patients.created_at::Date = ?", Date.today).count
    in_clinic = Patient.where("ID NOT IN (?)", PatientFlow.
      where(area_id: ClinicArea::CHECKOUT).select("patient_id").
      map(&:patient_id)
    ).count
    render json: {
      today: today,
      total: Patient.count,
      per_hour: Patient.where("created_at between ? and ?",
        Time.now - 1.hour, Time.now).count,
      in_clinic: in_clinic,
      check_outs_per_hour: PatientFlow.where(area_id: ClinicArea::CHECKOUT).
        where("created_at between ? and ?", Time.now - 1.hour, Time.now).count
    }
  end

  def summary
    summary = Reports::ClinicSummary.new("All")

    render json: {
      total_donated: summary.grand_total,
      registrations: summary.patient_count, # Should be unique patients
      checkouts:     summary.checkouts,     # Should be unique patients
      procedures:    summary.procedure_count,
      top_procedures: summary.procedures.limit(10).order("subtotal_count DESC").
        map {|p| { label: p.description, value: p.subtotal_count }}
    }
  end

  def support
    render json: SupportRequest.active.map {|s| s.station_description }
  end

  private

  def authenticate
    authenticate_or_request_with_http_digest("MOMMA") do |username|
      u = app_config['dashboard']['username']
      p = app_config['dashboard']['password']

      username == u && Digest::MD5.hexdigest([u,"MOMMA",p].join(":"))
    end
  end
end