module ReportsHelper


  def time_spans
    [ "All", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM",
      "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM" ]
  end
  
  def days(report)
    existing_dates = Patient.all(
      :select => "Date(patients.created_at) as created_at_date", 
      :group => report.date_sql("patients")
    ).map {|p| p.created_at_date }
    
    ["All", *existing_dates]
  end
end
