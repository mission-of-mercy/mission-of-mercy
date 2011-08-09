module Admin
  class MaintenanceController < ApplicationController
    before_filter :admin_required
    before_filter :set_current_tab

    def index

    end

    def reset
      reset_sql = %{
        ALTER SEQUENCE patients_id_seq RESTART WITH 1;
        ALTER SEQUENCE patient_procedures_id_seq RESTART WITH 1;
        ALTER SEQUENCE patient_prescriptions_id_seq RESTART WITH 1;
        ALTER SEQUENCE patient_pre_meds_id_seq RESTART WITH 1;
        ALTER SEQUENCE surveys_id_seq RESTART WITH 1; }

      Patient.destroy_all
      SupportRequest.destroy_all
      Survey.destroy_all
      Patient.connection.execute(reset_sql)

      flash[:notice] = "Clinic DB Reset"
      redirect_to admin_maintenance_path
    end

    private

    def set_current_tab
      @current_tab = "maintenance"
    end
  end
end
