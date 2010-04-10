class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string  :number
      t.string  :first_name
      t.string  :last_name
      t.integer :treatment_area_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :providers
  end
end
