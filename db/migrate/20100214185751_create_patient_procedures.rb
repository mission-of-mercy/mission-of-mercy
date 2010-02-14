class CreatePatientProcedures < ActiveRecord::Migration
  def self.up
    create_table :patient_procedures do |t|
      t.integer  "patient_id"
      t.integer  "procedure_id"
      t.string   "tooth_number"
      t.string   "surface_code"
      t.integer  "provider_id"
      
      t.timestamps
    end
    
    add_index :patient_procedures, :patient_id, :unique => false
    add_index :patient_procedures, :procedure_id, :unique => false
  end

  def self.down
    remove_index :patient_procedures, :patient_id
    remove_index :patient_procedures, :procedure_id
    
    drop_table :patient_procedures
  end
end
