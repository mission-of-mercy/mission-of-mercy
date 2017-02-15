class UpdateSurveyQuestions < ActiveRecord::Migration
  def change
    change_table(:surveys) do |t|
      t.remove :own_a_toothbrush

      t.remove :six_mo_visited_dental_office
      t.remove :six_mo_visited_apple_clinic
      t.remove :six_mo_visited_clay_county_cares
      t.remove :six_mo_visited_sulzbacher_clinic
      t.remove :six_mo_visited_baptist_emergency
      t.remove :six_mo_visited_memorial_hospital_emergency
      t.remove :six_mo_visited_orange_park_emergency
      t.remove :six_mo_visited_st_vincent_emergency
      t.remove :six_mo_visited_uf_emergency
      t.remove :six_mo_visited_other

      t.text :main_reason_for_visit

      # Other reasons for visit
      t.boolean :other_reason_none
      t.boolean :other_reason_emergency
      t.boolean :other_reason_cant_afford
      t.boolean :other_reason_no_insurance
      t.boolean :other_reason_dont_want_to_spend_money
      t.boolean :other_reason_cant_get_appt
      t.boolean :other_reason_cant_take_time_from_work
      t.boolean :other_reason_office_too_far_away
      t.boolean :other_reason_office_hours_inconvienient
      t.boolean :other_reason_no_transportation
      t.boolean :other_reason_dont_know_where_to_go
      t.boolean :other_reason_told_to_come
      t.text    :other_reason_other

      # Smoking

      t.boolean :tobacco_cigarettes
      t.boolean :tobacco_pipes
      t.boolean :tobacco_cigars
      t.boolean :tobacco_hookahs
      t.boolean :tobacco_e_cigarettes
      t.boolean :tobacco_chewing
      t.boolean :tobacco_snuff
      t.boolean :tobacco_snus
      t.boolean :tobacco_dissolvales

      # Visited in the past 12 months
      t.boolean :twelve_mo_visited_dentist
      t.boolean :twelve_mo_visited_good_samaritan
      t.boolean :twelve_mo_visited_st_joe
      t.boolean :twelve_mo_visited_health_and_hope
      t.boolean :twelve_mo_visited_baptist_emergency
      t.boolean :twelve_mo_visited_sacred_emergency
      t.boolean :twelve_mo_visited_w_florida_emergency
      t.boolean :twelve_mo_visited_santa_rosa_emergency
      t.boolean :twelve_mo_visited_escambia_clinic
      t.boolean :twelve_mo_visited_pensacola_clinic
      t.text    :twelve_mo_visited_other
    end
  end
end
