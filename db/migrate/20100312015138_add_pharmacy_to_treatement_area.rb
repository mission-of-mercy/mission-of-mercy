class AddPharmacyToTreatmentArea < ActiveRecord::Migration
  def self.up
    add_column :treatment_areas, :pharmacy, :boolean
  end

  def self.down
    remove_column :treatment_areas, :pharmacy
  end
end
