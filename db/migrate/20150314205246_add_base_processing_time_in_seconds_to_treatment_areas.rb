class AddBaseProcessingTimeInSecondsToTreatmentAreas < ActiveRecord::Migration
  def change
    add_column :treatment_areas, :base_processing_time_in_seconds, :integer
  end
end
