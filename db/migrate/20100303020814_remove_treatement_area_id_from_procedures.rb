class RemoveTreatmentAreaIdFromProcedures < ActiveRecord::Migration
  def self.up
    remove_column :procedures, :treatment_area_id
  end

  def self.down
    add_column :procedures, :treatment_area_id, :integer
  end
end
