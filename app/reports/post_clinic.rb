class Reports::PostClinic
  attr_reader :town_count, :towns, :ethnicities, :ages, :travel_times,
              :avg_travel_time, :genders, :previous_moms, :insurances,
              :tobacco_use, :ratings, :areas, :time_in_pain, :counties,
              :distinct_previous_moms, :heard_about_clinic, :patient_count,
              :told_needed_more_dental_treatment, :tobacco_use_ages,
              :has_place_to_be_seen_for_dental_care, :last_dental_visit,
              :average_rating

  def initialize
    @patient_count = Patient.count

    load_towns
    load_counties
    load_ethnicities
    load_ages
    load_travel_times
    load_genders
    load_previous_moms
    load_insurance
    load_tobacco_use
    load_ratings
    load_treatment_areas
    load_time_in_pain
    load_heard_about_clinic
    load_told_needed_more_dental_treatment
    load_has_place_to_be_seen_for_dental_care
    load_tobacco_use_ages
    load_last_dental_visit
  end

  def load_treatment_areas
    sql = %{SELECT treatment_areas.name,
                   count(distinct patient_procedures.patient_id) as patient_count
            FROM treatment_areas LEFT JOIN procedure_treatment_area_mappings
                 ON treatment_areas.id = procedure_treatment_area_mappings.treatment_area_id
                 LEFT JOIN patient_procedures
                 ON procedure_treatment_area_mappings.procedure_id = patient_procedures.procedure_id
            WHERE    treatment_areas.amalgam_composite_procedures = 'f' OR
                     treatment_areas.amalgam_composite_procedures IS NULL
            GROUP BY treatment_areas.name
            ORDER BY treatment_areas.name}

    @areas = Patient.connection.select_all(sql).to_a

    treatment_areas = TreatmentArea.where(:amalgam_composite_procedures => true)
    treatment_areas.each do |treatment_area|
      amalgam_composite_sql = %{
        SELECT DISTINCT patient_procedures.patient_id
        FROM   patient_procedures LEFT JOIN procedures ON
               patient_procedures.procedure_id = procedures.id
        WHERE  procedures.procedure_type = 'Amalgam' OR
               procedures.procedure_type LIKE '%Composite' }

      amalgam_composite_patients = Patient.connection.select_values(amalgam_composite_sql)

      other_procedures_sql = %{
        SELECT DISTINCT patient_procedures.patient_id
        FROM procedure_treatment_area_mappings LEFT JOIN patient_procedures
             ON procedure_treatment_area_mappings.procedure_id = patient_procedures.procedure_id
        WHERE procedure_treatment_area_mappings.treatment_area_id = #{treatment_area.id}}

      other_procedures_patients = Patient.connection.select_values(other_procedures_sql)

      @areas << {
        "name"          => treatment_area.name,
        "patient_count" => (amalgam_composite_patients + other_procedures_patients).uniq.length
      }
    end

    calculate_percentage @areas

    sql = %{SELECT count(distinct patients.id)
            FROM   patients LEFT JOIN patient_flows ON patients.id = patient_flows.patient_id
            WHERE  patient_flows.area_id = #{ClinicArea::CHECKOUT}}

    remaining = @patient_count - Patient.connection.select_value(sql).to_i

    @areas << { "name" => "Never checked out",
                "patient_count" => remaining,
                "percent" => sprintf('%.2f', (remaining / @patient_count.to_f) * 100.0)
              }
  end

  def load_towns
    sql = %{SELECT initcap(patients.city) AS city, patients.state, count(*) as patient_count
            FROM patients
            GROUP BY initcap(patients.city), patients.state
            ORDER BY patients.state, initcap(patients.city)}

    @towns = Patient.connection.select_all(sql)

    calculate_percentage @towns

    @town_count = @towns.count
  end

  def load_counties
    sql = %{SELECT patient_zipcodes.county, patients.state, count(distinct patients.id) as patient_count
            FROM patients LEFT JOIN patient_zipcodes ON patients.zip = patient_zipcodes.zip
            GROUP BY patients.state, patient_zipcodes.county
            ORDER BY patients.state, patient_zipcodes.county }

    @counties = Patient.connection.select_all(sql)

    calculate_percentage @counties
  end

  def load_ethnicities
    sql = %{SELECT trim(initcap(surveys.race)) as race, count(*) as patient_count
            FROM surveys
            GROUP BY trim(initcap(surveys.race))
            ORDER BY trim(initcap(surveys.race))}

    @ethnicities = Patient.connection.select_all(sql)


    calculate_percentage @ethnicities
  end

  # TODO: Make this suck less
  #
  def load_ages
    patients = Survey.select("age")
    @ages = []

    count = patients.reject {|p| !(p.age <= 10) }.length

    @ages << {"age" => "between 1 and 10",
              "patient_count" => count}

    count = patients.reject {|p| !(p.age > 10 and p.age <= 20) }.length

    @ages << {"age" => "between 11 and 20",
              "patient_count" => count}

    count = patients.reject {|p| !(p.age > 20 and p.age <= 30) }.length

    @ages << {"age" => "between 21 and 30",
              "patient_count" => count}

    count = patients.reject {|p| !(p.age > 30 and p.age <= 40) }.length

    @ages << {"age" => "between 31 and 40",
              "patient_count" => count}

    count = patients.reject {|p| !(p.age > 40 and p.age <= 50) }.length

    @ages << {"age" => "between 41 and 50",
              "patient_count" => count}

    count = patients.reject {|p| !(p.age > 50 and p.age <= 60) }.length

    @ages << {"age" => "between 51 and 60",
              "patient_count" => count}

    count = patients.reject {|p| !(p.age > 60) }.length

    @ages << {"age" => "over 60",
              "patient_count" => count}

    count = patients.reject {|p| !(p.age <= 18) }.length

    @ages << {"age" => "18 and under",
              "patient_count" => count}

    calculate_percentage @ages

    @ages.extend(AggregateMeta)

    @ages.min = Survey.minimum(:age)
    @ages.max = Survey.maximum(:age)
    @ages.avg = sprintf('%.2f', Survey.average(:age) || 0)
  end

  def load_travel_times
    sql = %{SELECT patients.travel_time, count(*) as patient_count
            FROM patients
            GROUP BY patients.travel_time
            ORDER BY patients.travel_time}

    @travel_times = Patient.connection.select_all(sql)

    sql = %{SELECT avg(patients.travel_time) as average_travel_time
            FROM patients}

    @avg_travel_time = Patient.connection.select_value(sql)

    @avg_travel_time ||= 0
    @avg_travel_time = sprintf('%.2f', @avg_travel_time.to_f)
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
            GROUP BY location, clinic_year
            ORDER BY clinic_year}

    @previous_moms = Patient.connection.select_all(sql)

    calculate_percentage @previous_moms

    distinct_sql = %{SELECT count(distinct patient_id)
                     FROM patient_previous_mom_clinics }

    @distinct_previous_moms = Patient.connection.select_value(distinct_sql)
  end

  def load_insurance
    @insurances = []

    ["no_insurance", "insurance_from_job", "medicaid_or_chp_plus",
     "self_purchase_insurance", "other_insurance"].each do |i|
      add_insurance i
    end

    calculate_percentage @insurances
  end

  def load_tobacco_use
    sql = %{SELECT COALESCE(tobacco_use, 'f') AS tobacco,
                   count(*) as patient_count
            FROM surveys
            GROUP BY COALESCE(tobacco_use, 'f')}

    @tobacco_use = Patient.connection.select_all(sql)

    calculate_percentage @tobacco_use
  end

  def load_tobacco_use_ages
    sql = %{SELECT age, count(*) as patient_count
            FROM surveys
            WHERE tobacco_use = 't'
            GROUP BY age}

    ages = Patient.connection.select_all(sql)

    @tobacco_use_ages = Hash.new(0)

    ages.each do |age|
      group = age["age"].to_i == 0 % 10 ? age["age"].to_i : age["age"].to_i - (age["age"].to_i % 10)

      @tobacco_use_ages[group] += age["patient_count"].to_i
    end

    @tobacco_use_ages = @tobacco_use_ages.to_a.map do |age, count|
      {"age" => age, "patient_count" => count, "range" => "between #{age} and #{age + 10}"}
    end.sort {|x,y| x["age"] <=> y["age"] }

    calculate_percentage @tobacco_use_ages
  end

  def load_ratings
    sql = %{SELECT rating_of_services, count(*) as patient_count
            FROM surveys
            GROUP BY rating_of_services
            ORDER BY rating_of_services}

    @ratings = Patient.connection.select_all(sql)

    @average_rating = Survey.where("rating_of_services is not null").
      average(:rating_of_services)

    calculate_percentage @ratings
  end

  def load_time_in_pain
    sql = %{SELECT max(pain_length_in_days) AS max_length,
                   min(pain_length_in_days) AS min_length,
                   avg(pain_length_in_days) AS avg_length,
                   count(*) AS patient_count
            FROM surveys
            WHERE pain = 't' and pain_length_in_days > 0}

    @time_in_pain = Patient.connection.select_all(sql).first
  end

  def load_heard_about_clinic
    sql = %{SELECT trim(initcap(heard_about_clinic)) AS heard_about_clinic,
                   count(*) AS patient_count
            FROM surveys
            GROUP BY trim(initcap(heard_about_clinic))
            ORDER BY trim(initcap(heard_about_clinic))}

    @heard_about_clinic = Patient.connection.select_all(sql)

    calculate_percentage @heard_about_clinic
  end

  def load_told_needed_more_dental_treatment
    sql = %{SELECT told_needed_more_dental_treatment, count(*) AS patient_count
            FROM surveys
            WHERE told_needed_more_dental_treatment IS NOT NULL
            GROUP BY told_needed_more_dental_treatment}

    @told_needed_more_dental_treatment = Patient.connection.select_all(sql)

    calculate_percentage @told_needed_more_dental_treatment
  end

  def load_has_place_to_be_seen_for_dental_care
    sql = %{SELECT COALESCE(has_place_to_be_seen_for_dental_care, 'f') AS has_place,
                   count(*) AS patient_count
            FROM surveys
            GROUP BY COALESCE(has_place_to_be_seen_for_dental_care, 'f')}

    @has_place_to_be_seen_for_dental_care = Patient.connection.select_all(sql)

    calculate_percentage @has_place_to_be_seen_for_dental_care
  end

  def load_last_dental_visit
    sql = %{SELECT last_dental_visit, count(*) AS patient_count
            FROM patients
            GROUP BY last_dental_visit}

    @last_dental_visit = Patient.connection.select_all(sql)

    calculate_percentage @last_dental_visit
  end

  private

  def calculate_percentage(data)
    total_patients = 0

    data.each do |d|
      d["percent"] = (d["patient_count"].to_f / @patient_count.to_f) * 100.0
      d["percent"] = sprintf('%.2f', d["percent"])

      total_patients += d["patient_count"].to_i
    end

    total_patients
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

module AggregateMeta
  attr_accessor :min, :max, :avg
end
