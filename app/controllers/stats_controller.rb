class StatsController < ApplicationController
  def index
    stats = Dashboard.new
    @patients = stats.patients_summary
    @summary  = stats.clinic_summary

    render layout: false
  end
end
