class CreatePatientAssignments < ActiveRecord::Migration
  def change
    create_table :patient_assignments do |t|
      t.references :patient
      t.references :treatment_area
      t.datetime :checked_out_at

      t.timestamps
    end
  end
end
