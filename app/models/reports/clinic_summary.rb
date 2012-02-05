class Reports::ClinicSummary < ActiveRecord::Base
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

    if span == "All" || @day == "All"
      @span_time = "All"
      @span      = "All"
    else
      # Parse time with current date to make sure any timezone offsets are correct

      @span_time = Time.zone.parse(
        [@day.strftime('%Y-%m-%d'),span].join(' ')
      ).utc.strftime("%H:%M:00")
    end

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

  def date_sql(table)
    date_time_sql "Date", table
  end

  def time_sql(table)
    date_time_sql "Time", table
  end

  def date_time_sql(datetime, table)
    "#{table}.created_at::#{datetime}"
  end

  def date_time_where(q, table)
    unless @day == "All"
      q = q.where("#{date_sql(table)} = ?", @day)
      q = q.where("#{time_sql(table)} <= ?", @span_time) unless @span == "All"
    end
    q
  end

  private

  def load_patient_count  
    @patient_count = date_time_where(Patient, 'patients').count.to_i 
  end

  def load_xray_count
    load_area_count(ClinicArea::XRAY)
  end

  def load_checkout_count
    load_area_count(ClinicArea::CHECKOUT)
  end

  def load_area_count(area_id)
    q = PatientFlow.where('area_id = ?', area_id)
    q = date_time_where(q, 'patient_flows')
    q.count.to_i
  end

  def sum_count_and_value(rows)
    # Where count and value are the last two columns of a 2d array
    [ rows.sum {|p| p[-2]}, rows.sum {|p| p[-1]} ]
  end

  def collect_procedures
    q = PatientProcedure.select(%q{
      code, description,
      count(*) AS procedure_count,
      count(*) * procedures.cost AS procedure_value})
      .joins(:procedure)
      .group('procedures.code, procedures.description, procedures.cost')
    q = date_time_where(q, 'patient_procedures')

    @procedures = q.map do |p|
      [p["code"] + ": " + p["description"].titleize,
       p["procedure_count"].to_i,
       p["procedure_value"].to_f ]
    end

    @procedure_count, @procedure_value = *sum_count_and_value(@procedures)
  end

  def collect_prescriptions
    q = PatientPrescription.select(%q{
      prescriptions.id, prescriptions.name,
      count(*) AS prescription_count,
      count(*) * cost AS prescription_value})
      .joins(:prescription)
      .group('prescriptions.id, name, cost')
    q = date_time_where(q, 'patient_prescriptions')

    @prescriptions = q.map do |p|
      desc = Prescription.find(p["id"]).full_description
      [ desc, p["prescription_count"].to_i, p["prescription_value"].to_f ]
    end

    @prescription_count, @prescription_value = *sum_count_and_value(@prescriptions)
  end

  def collect_pre_meds
    q = PatientPreMed.select(%q{
      description,
      count(*) AS pre_med_count,
      count(*) * cost AS pre_med_value})
      .joins(:pre_med)
      .group('description, cost')
    q = date_time_where(q, 'patient_pre_meds')

    @pre_meds = q.map do |p|
      [ p["description"], p["pre_med_count"].to_i, p["pre_med_value"].to_f ]
    end

    @pre_med_count, @pre_med_value = *sum_count_and_value(@pre_meds)
  end

end
