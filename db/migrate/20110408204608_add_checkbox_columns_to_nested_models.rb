class AddCheckboxColumnsToNestedModels < ActiveRecord::Migration
  def self.up
    add_column :patient_previous_mom_clinics, :attended,   :boolean
  end

  def self.down
    remove_column :patient_previous_mom_clinics, :attended
  end
end
