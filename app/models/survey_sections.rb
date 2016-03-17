class SurveySections
  def initialize(survey)
    @survey = survey
  end

  attr_reader :survey

  def visit_information
    @visit_information ||= begin
      columns = [:reason_for_visit, :pain, :time_in_pain, :overall_health,
                 :travel_time, :heard_about_clinic, :attended_previous_mom]
      counts = {
        total_questions: columns.count,
        questions_answered: columns.count {|c| survey.attribute_present?(c) }
      }

      if survey.pain == false && !survey.attribute_present?(:time_in_pain)
        counts[:questions_answered] += 1
      end

      counts[:completed] = counts[:total_questions] == counts[:questions_answered]

      counts
    end
  end

  def health
    @health ||= begin
      columns = [:overall_dental_health, :own_a_toothbrush, :last_dental_visit,
                 :dental_care_home, :emergency_room_for_dental,
                 :frequency_of_emergency_dental_visits_past_6_months,
                 :told_need_more_dental_care_after_emergency_visit,
                 :six_mo_visited, :dental_insurance_coverage]

      counts = {
        total_questions: columns.count,
        questions_answered: columns.count do |c|
          if c == :six_mo_visited
            six_mo_columns = Survey.column_names.grep(/six_mo_visited/)

            six_mo_columns.any? {|c| survey[c].present? }
          else
            survey.attribute_present?(c)
          end
        end
      }

      if survey.emergency_room_for_dental == false
        if !survey.attribute_present?(:frequency_of_emergency_dental_visits_past_6_months)
          counts[:questions_answered] += 1
        end

        if !survey.attribute_present?(:told_need_more_dental_care_after_emergency_visit)
          counts[:questions_answered] += 1
        end
      end

      counts[:completed] = counts[:total_questions] == counts[:questions_answered]

      counts
    end
  end

  def about_you
    @about_you ||= begin
      columns = [:highest_level_of_school_completed, :health_insurance,
        :military_service, :hispanic_latino_spanish, :race,
        :current_work_situation]

      counts = {
        total_questions: columns.count,
        questions_answered: columns.count do |c|
          if c == :health_insurance
            health_columns = Survey.column_names.grep(/health_insurance/)

            health_columns.any? {|c| survey[c].present? }
          else
            survey.attribute_present?(c)
          end
        end
      }

      counts[:completed] = counts[:total_questions] == counts[:questions_answered]

      counts
    end
  end

  def household
    @household ||= begin
      columns = [:household_size, :food_stamps, :wic_program_benefits,
                 :household_anual_income]

      counts = {
        total_questions: columns.count,
        questions_answered: columns.count {|c| survey.attribute_present?(c) }
      }

      counts[:completed] = counts[:total_questions] == counts[:questions_answered]

      counts
    end
  end

  def totals
    @totals ||= begin
      counts = { total_questions: 0,
        questions_answered: 0,
        completed: false
      }

      sections = [:visit_information, :health, :about_you, :household]

      unless survey.consent_to_research_study
        sections -= [:health]
      end

      sections.each do |section|
        data = send(section)
        counts[:total_questions]    += data[:total_questions]
        counts[:questions_answered] += data[:questions_answered]
      end

      counts[:completed] = counts[:total_questions] == counts[:questions_answered]

      counts
    end
  end
end
