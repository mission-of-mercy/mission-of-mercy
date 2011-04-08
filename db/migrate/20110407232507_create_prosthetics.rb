class CreateProsthetics < ActiveRecord::Migration
  def self.up
    create_table :prosthetics do |t|
      t.belongs_to :patient
      t.string     :pickup
      t.text       :notes
      
      t.timestamps
    end
  end

  def self.down
    drop_table :prosthetics
  end
end
