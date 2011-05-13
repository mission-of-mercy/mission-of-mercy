class AddPrescribedToPatientPremeds < ActiveRecord::Migration
  def self.up
    add_column :patient_pre_meds, :prescribed, :boolean
  end

  def self.down
    remove_column :patient_pre_meds, :prescribed
  end
end
