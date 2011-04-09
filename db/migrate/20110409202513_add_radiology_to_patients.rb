class AddRadiologyToPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :radiology, :boolean, :default => false
  end

  def self.down
    remove_column :patients, :radiology
  end
end
