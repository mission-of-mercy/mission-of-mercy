class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :category
      t.timestamps
    end
  end
end
