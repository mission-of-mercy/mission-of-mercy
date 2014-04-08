class AddPregnancyQuestionsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :pregnant,   :boolean, default: false, null: false
    add_column :patients, :has_obgyn,  :boolean, default: false, null: false
    add_column :patients, :due_date,   :date
    add_column :patients, :follow_up,  :boolean, default: false, null: false
    add_column :patients, :obgyn_name, :text
  end
end
