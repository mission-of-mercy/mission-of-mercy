class AddAmalgamCompositeProceduresToTreatementArea < ActiveRecord::Migration
  def self.up
    add_column :treatement_areas, :amalgam_composite_procedures, :boolean
  end

  def self.down
    remove_column :treatement_areas, :amalgam_composite_procedures
  end
end
