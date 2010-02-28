class AddAssignedTreatmentAreaIdToPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :assigned_treatment_area_id, :integer
  end

  def self.down
    remove_column :patients, :assigned_treatment_area_id
  end
end
