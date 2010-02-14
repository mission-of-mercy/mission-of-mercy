class CreatePrescriptions < ActiveRecord::Migration
  def self.up
    create_table :prescriptions do |t|
      t.string   "name"
      t.string   "strength"
      t.integer  "quantity"
      t.string   "dosage"
      t.float    "cost"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :prescriptions
  end
end
