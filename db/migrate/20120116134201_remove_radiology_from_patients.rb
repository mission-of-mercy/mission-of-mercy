class RemoveRadiologyFromPatients < ActiveRecord::Migration
  def up
    remove_column :patients, :radiology
  end

  def down
    add_column :patients, :radiology, :boolean
  end
end
