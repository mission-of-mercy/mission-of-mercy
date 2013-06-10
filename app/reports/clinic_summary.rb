require 'time_scope'

class Reports::ClinicSummary
  attr_accessor :day, :span
  attr_reader   :patient_count, :procedures, :procedure_count, :procedure_value,
                :prescriptions, :prescription_count, :prescription_value,
                :grand_total, :next_chart_number, :xrays, :checkouts,
                :pre_med_count, :pre_meds, :pre_med_value,
                :procedures_per_hour, :patients_per_hour, :checkouts_per_hour,
                :xrays_per_hour

  TIME_SPANS = [ "All", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM",
                 "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM",
                 "4:00 PM", "5:00 PM" ]

  def initialize(day=Date.today, span="All")
    models = [ Patient, Prescription, PatientFlow, PreMed, Procedure,
               PatientProcedure ]

    models.each { |model| model.extend(TimeScope) }

    @day, @span = day, span

    @day  = Date.strptime(day, "%m/%d/%Y") if day.kind_of?(String) && day != "All"
    @span = "All" if span == "All" || @day == "All"

    collect_patients
    collect_xrays
    collect_checkouts
    collect_procedures
    collect_prescriptions
    collect_pre_meds

    @grand_total = @procedure_value + @prescription_value + @pre_med_value

    @next_chart_number = Patient.maximum(:id) || 0
    @next_chart_number += 1
  end

  def day_and_span
    return "Every day" if @day == "All" and @span == "All"

    if @span == "All"
      @day
    elsif @day == "All"
      ["Every day", @span].join(" at ")
    else
      [@day, @span].join(" at ")
    end
  end

  def patients_per_treatment_area
    @patients_per_treatment_area ||= begin
      patient_flows(ClinicArea::CHECKOUT).
        select("treatment_area_id, count(DISTINCT patient_id) as patient_count").
        group("treatment_area_id")
    end
  end

  def multivisit_patents
    @multivisit_patents ||= begin
      Patient.for_time('patients', day, span).
        where('previous_chart_number IS NOT NULL')
    end
  end

  def total_patient_charts
    @total_patient_charts ||= Patient.for_time('patients', day, span).count
  end

  def patients_never_checked_out
    @patients_never_checked_out ||= begin
      Patient.for_time('patients', @day, @span).
        joins(%{LEFT JOIN patient_flows ON
          patients.id = patient_flows.patient_id AND
          patient_flows.area_id = #{ClinicArea::CHECKOUT}}).
        where("patient_flows.id IS NULL").count
    end
  end

  private

  def collect_patients
    load_patient_count
    load_patients_per_hour
  end

  def load_patient_count
    @patient_count = Patient.for_time('patients', @day, @span).unique.count
  end

  def load_patients_per_hour
    query = Patient.for_time('patients', @day, @span)
    @patients_per_hour = records_per_hour(query)
  end

  def collect_xrays
    load_xray_count
    load_xrays_per_hour
  end

  def load_xray_count
    @xrays = area_count(ClinicArea::XRAY)
  end

  def load_xrays_per_hour
    query = patient_flows(ClinicArea::XRAY)
    @xrays_per_hour = records_per_hour(query)
  end

  def collect_checkouts
    load_checkout_count
    load_checkouts_per_hour
  end

  def load_checkout_count
    @checkouts = area_count(ClinicArea::CHECKOUT)
  end

  def load_checkouts_per_hour
    query = patient_flows(ClinicArea::CHECKOUT)
    @checkouts_per_hour = records_per_hour(query)
  end

  def area_count(area_id)
    patient_flows(area_id).select("COUNT(DISTINCT patient_id) as patient_count").
      first.patient_count
  end

  def patient_flows(area_id)
    PatientFlow.for_time('patient_flows', @day, @span).where(area_id: area_id)
  end

  def collect_procedures
    collect_total_procedures
    collect_procedures_per_hour
  end

  def collect_total_procedures
    query = Procedure.for_time('patient_procedures', @day, @span)

    summary = query.select(
      "count(*) as total_count, sum(procedures.cost) as total_cost")
      .joins(:patient_procedures).first

    @procedure_count = summary.total_count.to_i
    @procedure_value = summary.total_cost.to_f

    @procedures = query.select(%q{
      code, description,
      count(*) as subtotal_count,
      count(*) * cost as subtotal_value})
      .joins(:patient_procedures)
      .group('procedures.code, procedures.description, procedures.cost')
      .order('subtotal_count')
  end

  def collect_procedures_per_hour
    query = PatientProcedure.for_time('patient_procedures', @day, @span)
    @procedures_per_hour = records_per_hour(query)
  end

  def records_per_hour(query)
    records = query.
      select("TO_TIMESTAMP(TO_CHAR(created_at, 'YYYYMMDDHH2400'),'YYYYMMDDHH24MI') AS hour, COUNT(*) AS total").
      group('hour').
      order('hour')

    # Not sure why Postgres is returning the hour as a String instead of DateTime
    # and the total as a string. This loop normalizes to sensible classes
    records.each do |p|
      p.hour = Time.zone.parse(p.hour)
      p.total = p.total.to_i
    end
  end

  def collect_prescriptions
    query = Prescription.for_time('patient_prescriptions', @day, @span)

    summary = query.select(
      "count(*) as total_count, sum(cost) as total_cost")
      .joins(:patient_prescriptions).first

    @prescription_count = summary.total_count.to_i
    @prescription_value = summary.total_cost.to_f

    @prescriptions = query.select(%q{
      prescriptions.id, prescriptions.name,
      count(*) as prescription_count,
      count(*) * cost as prescription_value})
      .joins(:patient_prescriptions)
      .group('prescriptions.id, name, cost')
      .order('prescription_count')
  end

  def collect_pre_meds
    query = PreMed.for_time('patient_pre_meds', @day, @span)

    summary = query.select(
      "count(*) as total_count, sum(cost) as total_cost")
      .joins(:patient_pre_meds).first

    @pre_med_count = summary.total_count.to_i
    @pre_med_value = summary.total_cost.to_f

    @pre_meds = query.select(%q{
      description,
      count(*) as pre_med_count,
      count(*) * cost as pre_med_value})
      .joins(:patient_pre_meds)
      .group('description, cost')
      .order('pre_med_count')
  end

end
