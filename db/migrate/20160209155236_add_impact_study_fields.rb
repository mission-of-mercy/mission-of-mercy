class AddImpactStudyFields < ActiveRecord::Migration
  def change
    change_table(:patients) do |t|
      t.text :language
      t.boolean :consent_to_research_study, default: false, nil: false

      t.remove :travel_time
      t.remove :pain_length_in_days

      t.text :travel_time
      t.text :time_in_pain
    end

    change_table(:surveys) do |t|
      t.text :language
      t.boolean :consent_to_research_study, default: false, nil: false

      t.remove :pain_length_in_days
      t.text :travel_time
      t.text :time_in_pain

      t.remove :has_place_to_be_seen_for_dental_care
      t.remove :told_needed_more_dental_treatment
      t.remove :no_insurance
      t.remove :insurance_from_job
      t.remove :medicaid_or_chp_plus
      t.remove :self_purchase_insurance
      t.remove :other_insurance
      t.remove :saga_insurance
      t.remove :husky_insurance_a
      t.remove :husky_insurance_b
      t.remove :husky_insurance_c
      t.remove :husky_insurance_d
      t.remove :husky_insurance_unknown
      t.remove :charter_oak

      t.text :overall_health
      t.text :overall_dental_health
      t.boolean :own_a_toothbrush
      t.text    :dental_care_home
      t.boolean :emergency_room_for_dental
      t.text :frequency_of_emergency_dental_visits_past_6_months
      t.boolean :told_need_more_dental_care_after_emergency_visit

      # Visited in the past 12 months
      t.boolean :six_mo_visited_dental_office
      t.boolean :six_mo_visited_apple_clinic
      t.boolean :six_mo_visited_clay_county_cares
      t.boolean :six_mo_visited_sulzbacher_clinic
      t.boolean :six_mo_visited_baptist_emergency
      t.boolean :six_mo_visited_memorial_hospital_emergency
      t.boolean :six_mo_visited_orange_park_emergency
      t.boolean :six_mo_visited_st_vincent_emergency
      t.boolean :six_mo_visited_uf_emergency
      t.text    :six_mo_visited_other

      t.boolean :dental_insurance_coverage

      t.text :highest_level_of_school_completed

      t.boolean :health_insurance_none
      t.boolean :health_insurance_from_employer
      t.boolean :health_insurance_purchased_from_insurance_co
      t.boolean :health_insurance_purchased_from_gov
      t.boolean :health_insurance_medicare
      t.boolean :health_insurance_medicaid
      t.boolean :health_insurance_military
      t.boolean :health_insurance_other

      t.text :military_service

      t.boolean :hispanic_latino_spanish

      t.text :current_work_situation
      t.text :household_size
      t.boolean :food_stamps
      t.boolean :wic_program_benefits
      t.text :household_anual_income
    end
  end
end
