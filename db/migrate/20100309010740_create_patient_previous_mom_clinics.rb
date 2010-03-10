class CreatePatientPreviousMomClinics < ActiveRecord::Migration
  def self.up
    create_table :patient_previous_mom_clinics do |t|
      t.integer :patient_id
      t.string :location
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :patient_previous_mom_clinics
  end
end
