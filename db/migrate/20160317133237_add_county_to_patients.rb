class AddCountyToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :county, :string
  end
end
