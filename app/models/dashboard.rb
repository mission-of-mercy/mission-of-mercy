class Dashboard
  def initialize
    @patients = Patient.unique
  end

  def patients_summary
    registrations_today = patients.created_today.count
    registrations_total = patients.count
    in_clinic = Patient.created_today.joins(%{LEFT JOIN patient_flows ON
      patients.id = patient_flows.patient_id AND
      patient_flows.area_id = #{ClinicArea::CHECKOUT}}).
      where("patient_flows.id IS NULL").count

    check_outs = PatientFlow.where(area_id: ClinicArea::CHECKOUT).
      select("COUNT(DISTINCT patient_id) as patient_count")
    check_outs_total = check_outs.first.patient_count.to_i
    check_outs_today = check_outs.
      where("patient_flows.created_at::Date = ?", Date.today).
      first.patient_count.to_i

    registrations_per_hour = Patient.where("created_at between ? and ?",
      Time.now - 15.minutes, Time.now).count * 4
    check_outs_per_hour = PatientFlow.where(area_id: ClinicArea::CHECKOUT).
      where("created_at between ? and ?",
        Time.now - 15.minutes, Time.now).count * 4

    {
      registrations_today:    registrations_today,
      registrations_total:    registrations_total,
      check_outs_today:       check_outs_today,
      check_outs_total:       check_outs_total,
      in_clinic:              in_clinic,
      registrations_per_hour: registrations_per_hour,
      check_outs_per_hour:    check_outs_per_hour
    }
  end

  def clinic_summary
    total_donated = Procedure.joins(:patient_procedures).sum(:cost) +
      Prescription.joins(:patient_prescriptions).sum(:cost) +
      PreMed.joins(:patient_pre_meds).sum(:cost)
    procedures = Procedure.
      where("patient_procedures.created_at::Date = ?", Date.today).
      select("description, count(*) as subtotal_count").
      joins(:patient_procedures).
      group('procedures.description')
    top_procedures = procedures.where(auto_add: false).
      limit(10).order("subtotal_count DESC").
        map {|p| { label: p.description, value: p.subtotal_count }}

    {
      total_donated:  total_donated,
      procedures:     PatientProcedure.created_today.count,
      top_procedures: top_procedures
    }
  end

  def treatment_areas
    TreatmentArea.current_capacity.map do |area, count|
      { name: area, count: count }
    end
  end

  def support_requests
    SupportRequest.active.map {|s| s.station_description }
  end

  private

  attr_reader :patients
end
