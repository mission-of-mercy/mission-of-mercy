class AddUtilizeFreeCleaningToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :utilize_free_cleaning, :boolean
  end
end
