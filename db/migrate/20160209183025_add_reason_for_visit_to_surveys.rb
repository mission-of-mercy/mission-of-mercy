class AddReasonForVisitToSurveys < ActiveRecord::Migration
  def change
    change_table(:surveys) do |t|
      t.text :reason_for_visit
      t.boolean :attended_previous_mom
    end
  end
end
