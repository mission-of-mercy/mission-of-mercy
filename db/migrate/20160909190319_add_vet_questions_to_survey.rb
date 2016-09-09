class AddVetQuestionsToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :vet_able_to_access_dental_care, :boolean
    add_column :surveys, :vet_length_to_access_dental_care, :string
    add_column :surveys, :vet_family_able_to_access_dental_care, :boolean
    add_column :surveys, :currently_has_a_place_to_live, :boolean
  end
end
