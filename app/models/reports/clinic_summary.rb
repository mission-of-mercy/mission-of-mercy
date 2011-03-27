class Reports::ClinicSummary
  attr_accessor :day, :span
  attr_reader   :patient_count, :procedures, :procedure_count, :procedure_value, 
                :prescriptions, :prescription_count, :prescription_value, 
                :grand_total, :next_chart_number, :xrays, :checkouts,
                :pre_med_count, :pre_meds, :pre_med_value
  
  def initialize(day=Date.today, span="All")
    reload(day,span)
  end
  
  def reload(day, span)
    @day, @span = day, span
    @procedures, @prescriptions, @pre_meds = [], [], []
    
    @day = Date.parse(day) if day.kind_of?(String) && day != "All"
    span == "All" ? @span_time = span : @span_time = Time.parse(span).strftime("%H:%M:00")

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
      procedures.description, 
      count(patient_procedures.procedure_id) AS procedure_count, 
      count(patient_procedures.procedure_id) * procedures.cost AS procedure_value
      FROM procedures 
        LEFT JOIN patient_procedures ON procedures.id = patient_procedures.procedure_id}
      
    sql = date_time_where(sql, "patient_procedures")
      
    sql += %{ GROUP BY procedures.code, procedures.description, procedures.cost
      HAVING count(patient_procedures.procedure_id) > 0;}
      
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
      prescriptions.name, 
      prescriptions.strength, 
      prescriptions.quantity, 
      prescriptions.dosage, 
      count(patient_prescriptions.prescription_id) AS prescription_count, 
      count(patient_prescriptions.prescription_id) * prescriptions.cost AS prescription_value
      FROM prescriptions 
        LEFT JOIN patient_prescriptions ON prescriptions.id = patient_prescriptions.prescription_id}
      
    sql = date_time_where(sql, "patient_prescriptions")
      
    sql += %{ GROUP BY prescriptions.name, prescriptions.strength, 
    prescriptions.quantity, prescriptions.dosage, prescriptions.cost
      HAVING count(patient_prescriptions.prescription_id) > 0;}
      
    @prescriptions = Prescription.connection.select_all(
                      Prescription.send(:sanitize_sql_array, 
                      [sql, {:report_date => @day.to_s,
                             :report_time => @span_time}]))
                             
    @prescriptions.map! do |p|
      desc = [p["name"], p["strength"], ["#", p["quantity"]," -"].join(), p["dosage"]].join(' ')
      [desc,p["prescription_count"].to_i,p["prescription_value"].to_f ]
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
      HAVING count(patient_pre_meds.pre_med_id) > 0;}
      
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
