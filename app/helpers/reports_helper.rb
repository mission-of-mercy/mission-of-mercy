module ReportsHelper


  def time_spans
    Reports::ClinicSummary::TIME_SPANS
  end
  
  def days(report)
    existing_dates = Patient.all(
      :select => "patients.created_at::Date as created_at_date", 
      :group => report.date_sql("patients"),
      :order => "patients.created_at::Date"
    ).map {|p| p.created_at_date.to_date }
    
    ["All", *existing_dates]
  end
  
  def patients_by_county(county)
    conditions = "patients.state = ? AND patient_zipcodes.county "
    
    if county["county"].blank?
      county["county"] = nil
      conditions << "IS ?"
    else
      conditions << "= ?"
    end
    
    Patient.all(
      :select => "patients.id", 
      :include => [:zipcode],
      :conditions => [conditions, county["state"], county["county"]]
    ).map(&:id)
  end
  
  def county_filename(county)
    [county["state"], county["county"]].compact.join("_")
  end
  
  def percent_of_clinic(number_of_patients, total)
    percent = (number_of_patients.to_f / total.to_f) * 100.0
    sprintf('%.2f', percent)
  end
end
