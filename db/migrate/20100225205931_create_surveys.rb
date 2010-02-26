class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.integer :time_spent_at_clinic_in_minutes
      t.string :city
      t.string :state
      t.string :zip
      t.integer :age
      t.string :sex
      t.string :race
      t.boolean :pain
      t.integer :pain_length_in_days
      t.string :heard_about_clinic
      t.boolean :told_needed_more_dental_treatment
      t.boolean :has_place_to_be_seen_for_dental_care
      t.boolean :no_insurance
      t.boolean :insurance_from_job
      t.boolean :medicaid_or_chp_plus
      t.boolean :self_purchase_insurance
      t.boolean :husky_insurance
      t.boolean :saga_insurance
      t.string :other_insurance
      t.boolean :tobacco_use
      t.integer :rating_of_services

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
