class CreateTreatmentAreas < ActiveRecord::Migration
  def self.up
    create_table :treatment_areas do |t|
      t.string  :name
      t.integer :capacity 
      
      t.timestamps
    end
  end

  def self.down
    drop_table :treatment_areas
  end
end
