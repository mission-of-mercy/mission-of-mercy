class Dashboard
  def initialize
    @patients = Patient.unique
  end

  def patients_summary
    today     = patients.created_today.count
    total     = patients.count
    in_clinic = Patient.created_today.joins(%{LEFT JOIN patient_flows ON
      patients.id = patient_flows.patient_id AND
      patient_flows.area_id = #{ClinicArea::CHECKOUT}}).
      where("patient_flows.id IS NULL").count
    per_hour = Patient.where("created_at between ? and ?",
      Time.now - 1.hour, Time.now).count
    check_outs_per_hour = PatientFlow.where(area_id: ClinicArea::CHECKOUT).
      where("created_at between ? and ?", Time.now - 1.hour, Time.now).count

    {
      today:               today,
      total:               total,
      per_hour:            per_hour,
      in_clinic:           in_clinic,
      check_outs_per_hour: check_outs_per_hour
    }
  end

  def clinic_summary
    total_donated = Procedure.joins(:patient_procedures).sum(:cost) +
      Prescription.joins(:patient_prescriptions).sum(:cost) +
      PreMed.joins(:patient_pre_meds).sum(:cost)
    check_outs = PatientFlow.where(area_id: ClinicArea::CHECKOUT).
      where("patient_flows.created_at::Date = ?", Date.today).
      select(:patient_id).uniq.count
    procedures = Procedure.
      where("patient_procedures.created_at::Date = ?", Date.today).
      select("description, count(*) as subtotal_count").
      joins(:patient_procedures).
      group('procedures.description')
    top_procedures = procedures.limit(10).order("subtotal_count DESC").
        map {|p| { label: p.description, value: p.subtotal_count }}

    {
      total_donated:  total_donated,
      registrations:  patients.created_today.count,
      check_outs:     check_outs,
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
