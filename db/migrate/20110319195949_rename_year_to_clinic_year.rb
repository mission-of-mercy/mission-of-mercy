class RenameYearToClinicYear < ActiveRecord::Migration
  def self.up
    rename_column :patient_previous_mom_clinics, :year, :clinic_year
  end

  def self.down
    rename_column :patient_previous_mom_clinics, :clinic_year, :year
  end
end
