class CreatePreviousClinics < ActiveRecord::Migration
  def change
    create_table :previous_clinics do |t|
      t.string  :location
      t.integer :year

      t.timestamps
    end
  end
end
