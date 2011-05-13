class AddSurveyQuestions < ActiveRecord::Migration
  def self.up
    add_column :surveys, :pain,                                 :boolean 
    add_column :surveys, :pain_length_in_days,                  :integer 
    add_column :surveys, :heard_about_clinic,                   :string  
    add_column :surveys, :told_needed_more_dental_treatment,    :boolean 
    add_column :surveys, :has_place_to_be_seen_for_dental_care, :boolean 
    add_column :surveys, :no_insurance,                         :boolean 
    add_column :surveys, :insurance_from_job,                   :boolean 
    add_column :surveys, :medicaid_or_chp_plus,                 :boolean 
    add_column :surveys, :self_purchase_insurance,              :boolean 
    add_column :surveys, :other_insurance,                      :string  
    add_column :surveys, :tobacco_use,                          :boolean 
  end

  def self.down
    remove_column :surveys, :pain
    remove_column :surveys, :pain_length_in_days
    remove_column :surveys, :heard_about_clinic
    remove_column :surveys, :told_needed_more_dental_treatment
    remove_column :surveys, :has_place_to_be_seen_for_dental_care
    remove_column :surveys, :no_insurance  
    remove_column :surveys, :insurance_from_job
    remove_column :surveys, :medicaid_or_chp_plus
    remove_column :surveys, :self_purchase_insurance
    remove_column :surveys, :other_insurance   
    remove_column :surveys, :tobacco_use
  end
end
