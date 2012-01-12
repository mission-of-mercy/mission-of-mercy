class RemoveAssignedTreatmentAreaFromPatients < ActiveRecord::Migration
  def up
    remove_column :patients, :assigned_treatment_area_id
  end

  def down
    add_column :patients, :assigned_treatment_area_id, :integer
  end
end
