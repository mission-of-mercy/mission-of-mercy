class RemoveUnnecessaryPreMedAttributes < ActiveRecord::Migration
  def up
    remove_column :pre_meds, :count
    remove_column :pre_meds, :prescription_id
  end

  def down
    add_column :pre_meds, :count,           :integer
    add_column :pre_meds, :prescription_id, :integer
  end
end
