class Reports::ClinicSummary
  attr_accessor :day, :span
  attr_reader   :patient_count, :procedures, :procedure_count, :procedure_value,
                :prescriptions, :prescription_count, :prescription_value,
                :grand_total, :next_chart_number, :xrays, :checkouts,
                :pre_med_count, :pre_meds, :pre_med_value

  TIME_SPANS = [ "All", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM",
                 "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM",
                 "4:00 PM", "5:00 PM" ]

  def initialize(day=Date.today, span="All")
    reload(day,span)
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

  def reload(day, span)
    @day, @span = day, span
    @procedures, @prescriptions, @pre_meds = [], [], []

    @day = Date.strptime(day, "%m/%d/%Y") if day.kind_of?(String) && day != "All"
    @span = "All" if span == "All" || @day == "All"

    @patient_count = load_patient_count
    @xrays         = load_xray_count
    @checkouts     = load_checkout_count

    collect_procedures
    collect_prescriptions
    collect_pre_meds

    @grand_total = @procedure_value + @prescription_value + @pre_med_value

    @next_chart_number = Patient.maximum(:id) || 0
    @next_chart_number += 1
  end

  private

  def load_patient_count
    @patient_count = Patient.scope_by_time('patients', @day, @span).count.to_i 
  end

  def load_xray_count
    load_area_count(ClinicArea::XRAY)
  end

  def load_checkout_count
    load_area_count(ClinicArea::CHECKOUT)
  end

  def load_area_count(area_id)
    PatientFlow.scope_by_time('patient_flows', @day, @span)
      .where('area_id = ?', area_id).count.to_i
  end

  def collect_procedures
    query = Procedure.scope_by_time('patient_procedures', @day, @span)

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
  end

  def collect_prescriptions
    query = Prescription.scope_by_time('patient_prescriptions', @day, @span)

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
  end

  def collect_pre_meds
    query = PreMed.scope_by_time('patient_pre_meds', @day, @span)

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
  end

end
