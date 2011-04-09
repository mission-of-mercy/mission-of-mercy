class Reports::PostClinic
  attr_reader :town_count, :towns, :ethnicities, :ages, :travel_times, 
              :avg_travel_time, :genders, :previous_moms, :insurances,
              :tobacco_use, :ratings, :areas
  
  def initialize
    @patient_count = Patient.count
    
    load_towns
    load_ethnicities
    load_ages
    load_travel_times
    load_genders
    load_previous_moms
    load_insurance
    load_tobacco_use
    load_ratings
    load_treatment_areas
  end
  
  def load_treatment_areas
    sql = %{SELECT treatment_areas.name, count(*) as patient_count
            FROM 
            ( SELECT patient_flows.patient_id, patient_flows.treatment_area_id 
              FROM patient_flows 
              WHERE (patient_flows.area_id = 4 OR patient_flows.area_id = 2) AND treatment_area_id IS NOT NULL 
              GROUP BY patient_flows.patient_id, patient_flows.treatment_area_id
            ) AS pf LEFT JOIN treatment_areas  
            ON treatment_areas.id = pf.treatment_area_id
            GROUP BY treatment_areas.name}
    
    @areas = Patient.connection.select_all(sql)
    
    calculate_percentage @areas
  end
  
  def load_towns
    sql = %{SELECT patients.city, count(*) as patient_count
            FROM patients
            GROUP BY patients.city}
    
    @towns = Patient.connection.select_all(sql)
    
    calculate_percentage @towns
    
    @town_count = @towns.length
  end
  
  def load_ethnicities
    sql = %{SELECT patients.race, count(*) as patient_count
            FROM patients
            GROUP BY patients.race}
    
    @ethnicities = Patient.connection.select_all(sql)
    
    
    calculate_percentage @ethnicities
  end
  
  # TODO: Make this suck less
  #
  def load_ages    
    patients = Patient.all
    @ages = []
    
    count = patients.reject {|p| !(p.age <= 13) }.length
    
    @ages << {"age" => "between 1 and 13",
              "patient_count" => count}
              
    count = patients.reject {|p| !(p.age >= 14 and p.age <= 20) }.length

    @ages << {"age" => "between 14 and 20",
              "patient_count" => count}        
              
    count = patients.reject {|p| !(p.age >= 21 and p.age <= 64) }.length

    @ages << {"age" => "between 21 and 64",
              "patient_count" => count}  
              
    count = patients.reject {|p| !(p.age >= 65) }.length

    @ages << {"age" => "ages 65 and over",
              "patient_count" => count}
    
    calculate_percentage @ages
  end
  
  def load_travel_times
    sql = %{SELECT patients.travel_time, count(*) as patient_count
            FROM patients
            GROUP BY patients.travel_time}
    
    @travel_times = Patient.connection.select_all(sql)
    
    sql = %{SELECT avg(patients.travel_time) as average_travel_time
            FROM patients}
            
    @avg_travel_time = Patient.connection.select_value(sql)
    
    @avg_travel_time ||= 0
    @avg_travel_time = @avg_travel_time.to_f
  end
  
  def load_genders
    sql = %{SELECT patients.sex, count(*) as patient_count
            FROM patients
            GROUP BY patients.sex}
            
    @genders = Patient.connection.select_all(sql)
    
    calculate_percentage @genders
  end
  
  def load_previous_moms
    sql = %{SELECT location, clinic_year, count(*) as patient_count
            FROM patient_previous_mom_clinics
            GROUP BY patient_previous_mom_clinics.location, patient_previous_mom_clinics.clinic_year}
            
    @previous_moms = Patient.connection.select_all(sql)
    
    calculate_percentage @previous_moms
  end
  
  def load_insurance
    @insurances = []  
    
    ["no_insurance", "insurance_from_job", "medicaid_or_chp_plus",
     "self_purchase_insurance", "husky_insurance", "saga_insurance",
     "other_insurance"].each do |i|
      add_insurance i
    end
    
    calculate_percentage @insurances
  end
  
  def load_tobacco_use
    sql = %{SELECT tobacco_use, count(*) as patient_count
            FROM surveys
            GROUP BY tobacco_use}
            
    @tobacco_use = Patient.connection.select_all(sql)

    calculate_percentage @tobacco_use
  end
  
  def load_ratings
    sql = %{SELECT rating_of_services, count(*) as patient_count
            FROM surveys
            GROUP BY rating_of_services
            ORDER BY rating_of_services}
            
    @ratings = Patient.connection.select_all(sql)

    calculate_percentage @ratings
  end
  
  private
  
  def calculate_percentage(data)    
    data.each do |d|
      d["percent"] = (d["patient_count"].to_f / @patient_count.to_f) * 100.0
      d["percent"] = sprintf('%.2f', d["percent"])
    end
  end
  
  def add_insurance(insurance_name)
    sql = %{SELECT count(*) as #{insurance_name}
            FROM surveys
            WHERE #{insurance_name} = ?}
          
    count = Patient.connection.select_value(Patient.send(:sanitize_sql_array, 
            [sql, true]))
    
    @insurances << {"insurance" => insurance_name.humanize, 
                    "patient_count" => count}
  end
end
