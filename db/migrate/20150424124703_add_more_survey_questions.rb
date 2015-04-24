class AddMoreSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :surveys, :er_last_6_months, :boolean, default: false,
                                                      null: false
    add_column :surveys, :er_last_year,     :boolean, default: false,
                                                      null: false
  end
end
