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

    if span == "All" || @day == "All"
      @span_time = "All"
      @span      = "All"
    else
      # Parse time with current date to make sure any timezone offsets are correct
      
      @span_time = Time.parse([@day.strftime('%Y-%m-%d'),span].join(' ')).utc.strftime("%H:%M:00")
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
  
  def date_time_where(sql, table)
    if sql.include? "WHERE"
      start = "AND"
    else
      start = "WHERE"
    end
    
    unless @day == "All"
      sql += %{ #{start} #{date_sql(table)} = :report_date}
      sql += %{ AND #{time_sql(table)} <= :report_time} unless @span == "All"
    end
    
    sql
  end
  
  private
  
  def load_patient_count
    sql = %{SELECT count(patients.id) as "patient_count"
      FROM patients}
    
    sql = date_time_where(sql, 'patients')
    
    @patient_count = Patient.connection.select_value(
                      Patient.send(:sanitize_sql_array, 
                      [sql, {:report_date => @day.to_s,
                             :report_time => @span_time}]))
    
    @patient_count ||= 0
    @patient_count = @patient_count.to_i
  end
  
  def load_xray_count
    load_area_count(ClinicArea::XRAY)
  end
  
  def load_checkout_count
    load_area_count(ClinicArea::CHECKOUT)
  end
  
  def load_area_count(area_id)
    sql = %{SELECT count(*)
      FROM patient_flows
      WHERE patient_flows.area_id = :area_id}
    
    sql = date_time_where(sql, 'patient_flows')
    
    sql += %{ GROUP BY patient_flows.patient_id }
    
    count = Patient.connection.select_all(
              Patient.send(:sanitize_sql_array, 
              [sql, {:report_date => @day.to_s,
                     :report_time => @span_time,
                     :area_id     => area_id }])).length
    
    count ||= 0
    count.to_i
  end
  
  def collect_procedures    
    sql = %{SELECT 
      procedures.code, 
      initcap(procedures.description) AS description,
      count(patient_procedures.procedure_id) AS procedure_count, 
      count(patient_procedures.procedure_id) * procedures.cost AS procedure_value
      FROM procedures 
        LEFT JOIN patient_procedures ON procedures.id = patient_procedures.procedure_id}
      
    sql = date_time_where(sql, "patient_procedures")
      
    sql += %{ GROUP BY procedures.code, initcap(procedures.description), procedures.cost
      HAVING count(patient_procedures.procedure_id) > 0
      ORDER BY procedures.code;}
      
    @procedures = Procedure.connection.select_all(
                      Procedure.send(:sanitize_sql_array, 
                      [sql, {:report_date => @day.to_s,
                             :report_time => @span_time}]))
                             
    @procedures.map! {|p| [p["code"] + ": " + p["description"],p["procedure_count"].to_i,p["procedure_value"].to_f ] }
    
    @procedure_count = @procedures.sum {|p| p[1] }
    @procedure_value = @procedures.sum {|p| p.last }
  end
  
  def collect_prescriptions
    sql = %{SELECT 
      prescriptions.id, prescriptions.name,
      count(patient_prescriptions.prescription_id) AS prescription_count, 
      count(patient_prescriptions.prescription_id) * prescriptions.cost AS prescription_value
      FROM prescriptions 
        LEFT JOIN patient_prescriptions ON prescriptions.id = patient_prescriptions.prescription_id}
      
    sql = date_time_where(sql, "patient_prescriptions")
      
    sql += %{ GROUP BY prescriptions.id, prescriptions.name, prescriptions.cost
      HAVING count(patient_prescriptions.prescription_id) > 0
      ORDER BY prescriptions.name;}
      
    @prescriptions = Prescription.connection.select_all(
                      Prescription.send(:sanitize_sql_array, 
                      [sql, {:report_date => @day.to_s,
                             :report_time => @span_time}]))
                             
    @prescriptions.map! do |p|
      desc = Prescription.find(p["id"]).full_description
      [desc, p["prescription_count"].to_i, p["prescription_value"].to_f ]
    end
    
    @prescription_count = @prescriptions.sum {|p| p[1] }
    @prescription_value = @prescriptions.sum {|p| p.last }
  end
  
  def collect_pre_meds
    sql = %{SELECT 
      pre_meds.description, 
      count(patient_pre_meds.pre_med_id) AS pre_med_count, 
      count(patient_pre_meds.pre_med_id) * pre_meds.cost AS pre_med_value
      FROM pre_meds 
        LEFT JOIN patient_pre_meds ON pre_meds.id = patient_pre_meds.pre_med_id}
      
    sql = date_time_where(sql, "patient_pre_meds")
      
    sql += %{ GROUP BY pre_meds.description, pre_meds.cost
      HAVING count(patient_pre_meds.pre_med_id) > 0
      ORDER BY pre_meds.description;}
      
    @pre_meds = PreMed.connection.select_all(
                      PreMed.send(:sanitize_sql_array, 
                      [sql, {:report_date => @day.to_s,
                             :report_time => @span_time}]))
                             
    @pre_meds.map! do |p|
      [p["description"],p["pre_med_count"].to_i,p["pre_med_value"].to_f ]
    end
    
    @pre_med_count = @pre_meds.sum {|p| p[1] }
    @pre_med_value = @pre_meds.sum {|p| p.last }
  end
  
end
