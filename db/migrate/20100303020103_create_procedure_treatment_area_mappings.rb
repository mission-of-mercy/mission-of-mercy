class CreateProcedureTreatmentAreaMappings < ActiveRecord::Migration
  def self.up
    create_table :procedure_treatment_area_mappings do |t|
      t.integer :procedure_id
      t.integer :treatment_area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :procedure_treatment_area_mappings
  end
end
