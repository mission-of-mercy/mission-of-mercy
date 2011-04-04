class CreatePatientZipcodes < ActiveRecord::Migration
  def self.up
    create_table :patient_zipcodes do |t|
      t.string :zip
      t.string :city
      t.string :state
      t.string :latitude
      t.string :longitude
      
      t.timestamps
    end
    
    add_index :patient_zipcodes, :zip
  end

  def self.down
    drop_table :patient_zipcodes
  end
end
