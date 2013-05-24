require 'digest/md5'

class DashboardController < ApplicationController
  before_filter :authenticate
  before_filter :load_dashboard

  def patients
    render json: @dashboard.patients_summary
  end

  def summary
    render json: @dashboard.clinic_summary
  end

  def support
    render json: @dashboard.support_requests
  end

  def treatment_areas
    render json: @dashboard.treatment_areas
  end

  private

  def load_dashboard
    @dashboard = Dashboard.new
  end

  def authenticate
    authenticate_or_request_with_http_digest("MOMMA") do |username|
      u = app_config['dashboard']['username']
      p = app_config['dashboard']['password']

      username == u && Digest::MD5.hexdigest([u,"MOMMA",p].join(":"))
    end
  end
end
