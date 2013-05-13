class AddCustomSurveyQuestions < ActiveRecord::Migration
  def up
    add_column :surveys, :use_twitter,                           :boolean
    add_column :surveys, :use_facebook,                          :boolean
    add_column :surveys, :dental_insurance,                      :boolean
    add_column :surveys, :medical_insurance,                     :boolean
    add_column :surveys, :has_place_to_be_seen_for_medical_care, :boolean
  end

  def down
    remove_column :surveys, :use_twitter
    remove_column :surveys, :use_facebook
    remove_column :surveys, :dental_insurance
    remove_column :surveys, :medical_insurance
    remove_column :surveys, :has_place_to_be_seen_for_medical_care
  end
end
