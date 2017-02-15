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
      main_reason_for_visit: '9. What is the main reason you came here for dental care today?',
      other_reasons_for_visit: '10. What are the other reasons you came here for dental care today?',
      last_dental_visit: '11. About how long has it been since you last visited a dentist or dental clinic for any reason?',
      dental_care_home: '12. What kind of place do you usually go to when you need dental care?',
      emergency_room_for_dental: '13. Have you ever gone to a hospital emergency room for a dental problem?',
      frequency_of_emergency_dental_visits_past_6_months: '14. In the last 6 months how many times did you go to a hospital emergency room for a dental problem?',
      told_need_more_dental_care_after_emergency_visit: '15. Thinking about your last visit to an emergency room for a dental problem, before you left the emergency room, did someone tell you that you should go to a dentist’s office or dental clinic for additional care?',
      twelve_mo_visited_dentist: '16. visited a dentists office',
      twelve_mo_visited_good_samaritan: '16. Good Samaritan Clinich',
      twelve_mo_visited_st_joe: '16. St. Joseph’s/Our Lady of Angels Clinic',
      twelve_mo_visited_health_and_hope: '16. Health and Hope Clinic at Olive Baptist Church',
      twelve_mo_visited_baptist_emergency: '16. Baptist Hospital emergency room',
      twelve_mo_visited_sacred_emergency: '16. Sacred Heart Hospital Pensacola emergency room',
      twelve_mo_visited_w_florida_emergency: '16. West Florida Hospital emergency room',
      twelve_mo_visited_santa_rosa_emergency: '16. Santa Rosa Medical Center emergency room',
      twelve_mo_visited_escambia_clinic: '16. Escambia Community Clinic',
      twelve_mo_visited_pensacola_clinic: '16. Pensacola State College Dental Clinic',
      twelve_mo_visited_other: '16. Other',
      dental_insurance_coverage: '17. Do you have any kind of insurance coverage that pays for any costs for dental care?',
      tobacco_cigarettes: '18. Cigarettes',
      tobacco_pipes: '18. Pipes',
      tobacco_cigars: '18. Cigars/little cigars/cigarillos',
      tobacco_hookahs: '18. Water pipes or Hookahs',
      tobacco_e_cigarettes: '18. E-cigarettes',
      tobacco_chewing: '18. Chewing tobacco (such as Redman, Levi Garrett, or Beechnut)',
      tobacco_snuff: '18. Snuff (such as Skoal, Skoal Bandits, or Copenhagen)',
      tobacco_snus: '18. Snus',
      tobacco_dissolvales: '18. Dissolvables (such as strips or orbs)',
      highest_level_of_school_completed: '19. What is the highest grade or level of school that you have completed?',
      health_insurance_none: '20. No health insurance or health coverage of any type',
      health_insurance_from_employer: '20. Insurance from employer',
      health_insurance_purchased_from_insurance_co: '20. Insurance purchased directly from an insurance company',
      health_insurance_purchased_from_gov: '20. Insurance purchased through Healthcare.gov or Health Insurance Marketplace',
      health_insurance_medicare: '20. Medicare, for people 65 and older or people with certain disabilities',
      health_insurance_medicaid: '20. Medicaid, Medical Assistance, or government assistance for people with low incomes or a disability',
      health_insurance_military: '20. Military (TRICARE/VA/CHAMP-VA)',
      health_insurance_other: '20. Another type of health insurance or health coverage',
      military_service: '21. Did you ever serve on active duty in the U.S. Armed Forces, Reserves or National Guard?',
      hispanic_latino_spanish: '22. Are you of Hispanic or Latino or Spanish origin or descent?',
      race: '23. What is your race?',
      current_work_situation: '24. Which of the following best describes your current job or work situation?',
      household_size: '25. Including yourself, how many people are living or staying at your home address for more than 2 months?',
      food_stamps: '26. In the past 12 months did you or any member of your household receive benefits from the Food Stamp Program or SNAP (the Supplemental Nutrition Assistance Program)?',
      wic_program_benefits: '27. In the past 12 months did you or any member of your household receive benefits from the WIC program (the Women, Infants, and Children program)?',
      household_anual_income: '28. What is your best estimate of the total yearly income of all members in your household from all sources before taxes?'
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
