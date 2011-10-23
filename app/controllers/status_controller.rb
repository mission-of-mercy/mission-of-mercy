class StatusController < ApplicationController
  def index
    @requests = SupportRequest.find_all_by_resolved(false)

    sql = %{SELECT count(*) FROM patients
      WHERE patients.created_at::Date = '#{Date.today}'}

    @patients = Patient.connection.select_value(sql)

  end

end
