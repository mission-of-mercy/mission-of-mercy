include ActionView::Helpers::DateHelper

task :estimate => [:environment] do
  check_ins = PatientFlow.select("min(created_at) as check_in, patient_id").
    where(area_id: ClinicArea::CHECKIN).
    group("patient_id")
  check_outs = PatientFlow.select("max(created_at) as check_out, patient_id").
    where(area_id: ClinicArea::CHECKOUT).
    group("patient_id")

  if ENV['TODAY'].present?
    check_ins = check_ins.where("created_at::Date = ?", Date.today)
    check_outs = check_outs.where("created_at::Date = ?", Date.today)
  end

  patients = Patient.connection.select_all(%{
    SELECT avg(check_out - check_in) as patient_time
    FROM (#{check_ins.to_sql}) as i LEFT JOIN (#{check_outs.to_sql}) as o
    ON i.patient_id = o.patient_id
    WHERE check_out IS NOT NULL AND (check_out - check_in) < interval '8 hours'})

  puts patients.first["patient_time"]
end
