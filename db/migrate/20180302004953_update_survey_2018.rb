class UpdateSurvey2018 < ActiveRecord::Migration
  def change
    add_column :surveys, :twelve_mo_visited, :text
  end
end
