class AddSerializedFieldsToSurveys < ActiveRecord::Migration
  def change
    change_column :surveys, :heard_about_clinic, :text
    change_column :surveys, :race, :text
  end
end
