class CreateTreatementAreas < ActiveRecord::Migration
  def self.up
    create_table :treatement_areas do |t|
      t.string  :name
      t.integer :capacity 
      
      t.timestamps
    end
  end

  def self.down
    drop_table :treatement_areas
  end
end
