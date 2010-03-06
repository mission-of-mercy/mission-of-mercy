class CreatePreMeds < ActiveRecord::Migration
  def self.up
    create_table :pre_meds do |t|
      t.string  :description
      t.integer :count
      t.integer :prescription_id
      t.float   :cost

      t.timestamps
    end
  end

  def self.down
    drop_table :pre_meds
  end
end