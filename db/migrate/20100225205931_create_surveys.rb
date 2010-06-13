class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.string  :city
      t.string  :state
      t.string  :zip
      t.integer :age
      t.string  :sex
      t.string  :race
      t.integer :rating_of_services

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
