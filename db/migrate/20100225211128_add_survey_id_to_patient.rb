class AddSurveyIdToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :survey_id, :integer
  end

  def self.down
    remove_column :patients, :survey_id
  end
end
