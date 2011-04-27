class AddCountyToZipcodes < ActiveRecord::Migration
  def self.up
    add_column :patient_zipcodes, :county, :string
  end

  def self.down
    remove_column :patient_zipcodes, :county
  end
end
