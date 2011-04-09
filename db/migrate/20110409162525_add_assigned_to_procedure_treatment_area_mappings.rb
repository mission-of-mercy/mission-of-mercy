class AddAssignedToProcedureTreatmentAreaMappings < ActiveRecord::Migration
  def self.up
    add_column :procedure_treatment_area_mappings, :assigned, :boolean
  end

  def self.down
    remove_column :procedure_treatment_area_mappings, :assigned
  end
end
