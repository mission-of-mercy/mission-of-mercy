class AddOverallHealthToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :overall_health, :string
  end
end
