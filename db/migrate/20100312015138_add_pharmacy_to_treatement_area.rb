class AddPharmacyToTreatementArea < ActiveRecord::Migration
  def self.up
    add_column :treatement_areas, :pharmacy, :boolean
  end

  def self.down
    remove_column :treatement_areas, :pharmacy
  end
end
