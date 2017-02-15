class ChangeOtherReasonToSerialized < ActiveRecord::Migration
  def change
    change_table(:surveys) do |t|
      t.remove :other_reason_none
      t.remove :other_reason_emergency
      t.remove :other_reason_cant_afford
      t.remove :other_reason_no_insurance
      t.remove :other_reason_dont_want_to_spend_money
      t.remove :other_reason_cant_get_appt
      t.remove :other_reason_cant_take_time_from_work
      t.remove :other_reason_office_too_far_away
      t.remove :other_reason_office_hours_inconvienient
      t.remove :other_reason_no_transportation
      t.remove :other_reason_dont_know_where_to_go
      t.remove :other_reason_told_to_come
      t.remove :other_reason_other

      t.text :other_reasons_for_visit
    end
  end
end
