class AddAmalgamCompositeProceduresToTreatmentArea < ActiveRecord::Migration
  def self.up
    add_column :treatment_areas, :amalgam_composite_procedures, :boolean
  end

  def self.down
    remove_column :treatment_areas, :amalgam_composite_procedures
  end
end
