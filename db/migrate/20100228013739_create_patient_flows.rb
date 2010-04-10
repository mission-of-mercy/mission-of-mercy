class CreatePatientFlows < ActiveRecord::Migration
  def self.up
    create_table :patient_flows do |t|
      t.integer :treatment_area_id
      t.integer :patient_id
      t.integer :area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :patient_flows
  end
end
