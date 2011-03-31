module ReportsHelper


  def time_spans
    Reports::ClinicSummary::TIME_SPANS
  end
  
  def days(report)
    existing_dates = Patient.all(
      :select => "patients.created_at::Date as created_at_date", 
      :group => report.date_sql("patients")
    ).map {|p| p.created_at_date }
    
    ["All", *existing_dates]
  end
end
