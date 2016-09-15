class AddTravelMethodToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :travel_method, :text
    add_column :surveys,  :travel_method, :text
  end
end
