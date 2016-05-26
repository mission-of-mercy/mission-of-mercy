require 'csv'

class SurveyExporter
  FORMATS = {
    surveys: {
      age: 'Age',
      zip: 'Zip',
      patient: {
        county: 'County'
      },
      sex: 'Sex',
      rating_of_services: 'Rating of services',
      language: 'Language',
      reason_for_visit: '1. What is the reason for your visit today?',
      pain: '2. Are you having pain anywhere in your mouth?',
      time_in_pain: '3. How long have you had this pain?',
      overall_health: ' 4. Overall Health',
      travel_time: '5. Travel Time',
      heard_about_clinic: '6. Heard about clinic',
      attended_previous_mom: '7. Did you attend the Mission of Mercy clinic in Tampa in March, 2014?',
      overall_dental_health: '8. Overall Dental Health',
      own_a_toothbrush: '9. Owns a toothbrush',
      last_dental_visit: '10. About how long has it been since you last visited a dentist or dental clinic for any reason?',
      dental_care_home: '11. What kind of place do you usually go to when you need dental care?',
      emergency_room_for_dental: '12. Have you ever gone to a hospital emergency room for a dental problem?',
      frequency_of_emergency_dental_visits_past_6_months: '13. In the last 6 months how many times did you go to a hospital emergency room for a dental problem?',
      told_need_more_dental_care_after_emergency_visit: '14. Thinking about your last visit to an emergency room for a dental problem, before you left the emergency room, did someone tell you that you should go to a dentist’s office or dental clinic for additional care?',
      six_mo_visited_dental_office: '15. visited a dentists office',
      six_mo_visited_apple_clinic: '15. Apple clinic / Communuty health outreach',
      six_mo_visited_clay_county_cares: '15. Clay County Cares Dental Clnic / Gree Cove Springs',
      six_mo_visited_sulzbacher_clinic: '15. Sulzbacher Clinic',
      six_mo_visited_baptist_emergency: '15. Baptist Medical Center emergency room',
      six_mo_visited_memorial_hospital_emergency: '15. Memorial Hospital emergency room',
      six_mo_visited_orange_park_emergency: '15. Orange Park Medical Center emergency room',
      six_mo_visited_st_vincent_emergency: '15. St. Vincent’s Medical Center Riverside emergency room',
      six_mo_visited_uf_emergency: '15. University of Florida (UF) Health Jacksonville emergency room',
      six_mo_visited_other: '15. Other',
      dental_insurance_coverage: '16. Do you have any kind of insurance coverage that pays for any costs for dental care?',
      highest_level_of_school_completed: '17. What is the highest grade or level of school that you have completed?',
      health_insurance_none: '18. No health insurance or health coverage of any type',
      health_insurance_from_employer: '18. Insurance from employer',
      health_insurance_purchased_from_insurance_co: '18. Insurance purchased directly from an insurance company',
      health_insurance_purchased_from_gov: '18. Insurance purchased through Healthcare.gov or Health Insurance Marketplace',
      health_insurance_medicare: '18. Medicare, for people 65 and older or people with certain disabilities',
      health_insurance_medicaid: '18. Medicaid, Medical Assistance, or government assistance for people with low incomes or a disability',
      health_insurance_military: '18. Military (TRICARE/VA/CHAMP-VA)',
      health_insurance_other: '18. Another type of health insurance or health coverage',
      military_service: '19. Did you ever serve on active duty in the U.S. Armed Forces, Reserves or National Guard?',
      hispanic_latino_spanish: '20. Are you of Hispanic or Latino or Spanish origin or descent?',
      race: '21. What is your race?',
      current_work_situation: '22. Which of the following best describes your current job or work situation?',
      household_size: '23. Including yourself, how many people are living or staying at your home address for more than 2 months?',
      food_stamps: '24. In the past 12 months did you or any member of your household receive benefits from the Food Stamp Program or SNAP (the Supplemental Nutrition Assistance Program)?',
      wic_program_benefits: '25. In the past 12 months did you or any member of your household receive benefits from the WIC program (the Women, Infants, and Children program)?',
      household_anual_income: '26. What is your best estimate of the total yearly income of all members in your household from all sources before taxes?'
    },
    patient_procedures: {
      procedure: {
        code: 'Procedure Code',
        description: 'Procedure Description',
        cost: 'Cost'
      },
      tooth_number: 'Tooth Number',
      surface_code: 'Surface Code'
    }
  }

  def initialize(options = {})
    @options        = options
    @research_study = options.fetch(:research_study, false)
  end

  attr_reader :research_study

  # Public formatted records matching the requested +data_type+
  #
  # Returns a Hash of the data
  def data
    @data ||= begin
      results = {'surveys' => [], 'procedures' => []}
      id      = 1

      to_be_included = if research_study
        Patient.
          where(id: CSV.read('research_ids.csv').flatten.compact.map(&:to_i)).
          where("language in ('spanish', 'english')").
          where('date_of_birth <= ?', Date.civil(2016, 4, 22) - 18.years).
          select(:survey_id)
      else
        Patient.where('survey_id is not null').pluck(:survey_id)
      end

      Survey.where(id: to_be_included).order('random()').all.
        each do |survey|
        base_hash = {"id" => id}
        formatted_result = base_hash.merge(format(survey, :surveys))
        results['surveys'] << formatted_result

        patient = Patient.find_by(survey_id: survey.id)

        if patient
          patient.patient_procedures.each do |r|
            formatted_result = base_hash.merge(format(r, :patient_procedures))
            results['procedures'] << formatted_result
          end
        end
        id += 1
      end

      results
    end
  end

  private

  def format(record, data_type)
    formatted_record = FORMATS[data_type].map {|k,v| column(record, k, v) }
    Hash[*formatted_record.flatten]
  end

  # Private retrieve the requested column data
  #
  # record - Object with methods to be called
  # key    - String of the method name to call
  # value  - String of the column name OR Hash of methods to call
  #
  # Returns an array of column title and its corresponding data
  #
  def column(record, key, value)
    if Hash === value
      value.map {|k, v| column(record.try(key), k,v) }
    else
      record_value = record.try(key)
      if Array === record_value
        record_value = record_value.join(', ')
      end

      [value, record_value]
    end
  end
end
