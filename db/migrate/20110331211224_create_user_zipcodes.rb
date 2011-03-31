class CreateUserZipcodes < ActiveRecord::Migration
  def self.up
    create_table :user_zipcodes do |t|
      t.string :zip
      t.string :city
      t.string :state
      t.string :latitude
      t.string :longitude
      
      t.timestamps
    end
    
    add_index :user_zipcodes, :zip
  end

  def self.down
    drop_table :user_zipcodes
  end
end
