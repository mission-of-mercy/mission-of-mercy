class AddToldNeededMoreDentalTreatmentToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :told_needed_more_dental_treatment, :boolean
  end
end
