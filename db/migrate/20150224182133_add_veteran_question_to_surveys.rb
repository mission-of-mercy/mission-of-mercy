class AddVeteranQuestionToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :veteran, :boolean, null: false, default: false
  end
end
