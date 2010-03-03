class RemoveTreatementAreaIdFromProcedures < ActiveRecord::Migration
  def self.up
    remove_column :procedures, :treatement_area_id
  end

  def self.down
    add_column :procedures, :treatement_area_id, :integer
  end
end
