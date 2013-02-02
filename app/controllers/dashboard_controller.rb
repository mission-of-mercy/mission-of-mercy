class DashboardController < ApplicationController

  def patients
    today = Patient.where("patients.created_at::Date = ?", Date.today).count
    render json: { today: today, total: Patient.count }.to_json
  end
end