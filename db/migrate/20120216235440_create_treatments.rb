class CreateTreatments < ActiveRecord::Migration
  def change
    create_table :treatments do |t|
      t.string :name

      t.timestamps
    end
  end
end
