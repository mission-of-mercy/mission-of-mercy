class CreatePatientPreMeds < ActiveRecord::Migration
  def self.up
    create_table :patient_pre_meds do |t|
      t.integer :patient_id
      t.integer :pre_med_id

      t.timestamps
    end
  end

  def self.down
    drop_table :patient_pre_meds
  end
end
