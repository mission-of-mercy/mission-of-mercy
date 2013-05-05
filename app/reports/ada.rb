require 'axlsx'

module Reports
  class Ada
    def self.insurances
      @insurances ||= begin
        non_insurance_columns = %w[age sex race id city state zip
          rating_of_services created_at updated_at pain pain_length_in_days
          heard_about_clinic told_needed_more_dental_treatment
          has_place_to_be_seen_for_dental_care tobacco_use ]

        Survey.column_names - non_insurance_columns
      end
    end

    def initialize
      @xls   = Axlsx::Package.new
      @book  = @xls.workbook
    end

    def render_to_path(path)
      render
      @xls.use_shared_strings = true # For Numbers
      @xls.serialize(path)
    end

    class SurveyPresenter
      def initialize(survey)
        @survey  = survey
        @patient = Patient.where(survey_id: survey.id).first
      end

      def valid?
        @patient.present?
      end

      def to_a
        [
          survey.age,
          survey.sex,
          survey.race,
          patient.travel_time,
          *clinics,
          survey.told_needed_more_dental_treatment,
          survey.has_place_to_be_seen_for_dental_care,
          patient.last_dental_visit,
          survey.pain,
          survey.pain_length_in_days,
          survey.tobacco_use,
          *insurances
        ]
      end

      private

      attr_reader :survey, :patient

      def clinics
        PatientPreviousMomClinic::CLINICS.map do |year, location|
          patient.previous_mom_clinics.where(clinic_year: year,
                                             location: location).any?
        end
      end

      def insurances
        Reports::Ada.insurances.map do |column_name|
          survey.send(column_name)
        end
      end
    end

    private

    attr_reader :xls, :book

    def render
      book.add_worksheet(:name => "Mission of Mercy") do |sheet|
        sheet.add_row ["Age", "Gender", "Race", "Travel Time"] +
          PatientPreviousMomClinic::CLINICS.map {|n,y| [n,y].join(' ') } +
          ["Needs More Dental Care", "Has a Dentist", "Last Dental Visit",
           "In Pain?", "Pain Length in days", "Uses Tobacco?" ] +
          Reports::Ada.insurances.map(&:titleize)

        Survey.find_each do |survey|
          survey_presenter = SurveyPresenter.new(survey)
          sheet.add_row survey_presenter.to_a if survey_presenter.valid?
        end
      end
    end
  end
end
