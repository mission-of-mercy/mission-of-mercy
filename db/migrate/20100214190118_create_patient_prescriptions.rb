class CreatePatientPrescriptions < ActiveRecord::Migration
  def self.up
    create_table :patient_prescriptions do |t|
      t.integer  "patient_id"
      t.integer  "prescription_id"
      t.boolean  "prescribed"
      
      t.timestamps
    end
    
    add_index :patient_prescriptions, :patient_id, :unique => false
    add_index :patient_prescriptions, :prescription_id, :unique => false
  end

  def self.down
    remove_index :patient_prescriptions, :patient_id
    remove_index :patient_prescriptions, :prescription_id
    
    drop_table :patient_prescriptions
  end
end
