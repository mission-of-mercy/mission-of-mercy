class AddCostToPreMed < ActiveRecord::Migration
  def self.up
    add_column :pre_meds, :cost, :float
  end

  def self.down
    remove_column :pre_meds, :cost
  end
end
