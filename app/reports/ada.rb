require 'axlsx'

module Reports
  class Ada
    def initialize
      @xls  = Axlsx::Package.new
      @book = @xls.workbook
    end

    def render_to_path(path)
      render
      @xls.use_shared_strings = true # For Numbers
      @xls.serialize(path)
    end

    private

    attr_reader :xls, :book

    def render
      ages
      gender
      races
      travel_times
      previous_mom_clinics
      insurance
      last_dental_visit
      needs_more_dental_care
      has_dentist
    end

    def ages
      count_sheet "Ages", "age", ["Age", "Count"]
    end

    def gender
      count_sheet "Gender", "sex", ["Gender", "Count"]
    end

    def races
      count_sheet "Race", "race", ["Race / Ethnicity", "Count"]
    end

    def travel_times
      book.add_worksheet(:name => "Travel Time") do |sheet|
        t_times = Patient.unique.select("travel_time").order("travel_time")

        sheet.add_row ["Travel Time (in minutes)"]

        t_times.each do |row|
          sheet.add_row [row.travel_time]
        end
      end
    end

    def previous_mom_clinics
      book.add_worksheet(:name => "Previous MoM Clinics") do |sheet|
        counts = PatientPreviousMomClinic.
          select("clinic_year, location, count(*) as c").
          group("clinic_year, location").
          order("clinic_year, location")

        sheet.add_row ["Year", "Location", "Patient Count"]

        counts.each do |row|
          sheet.add_row [row.clinic_year, row.location, row.c]
        end
      end
    end

    def insurance
      columns = %w[city state zip age sex race rating_of_services created_at
      updated_at pain pain_length_in_days heard_about_clinic id
      told_needed_more_dental_treatment has_place_to_be_seen_for_dental_care]

      insurance_columns = Survey.column_names - columns

      book.add_worksheet(:name => "Insurance") do |sheet|
        sheet.add_row ["Question", "Patient Count"]

        insurance_columns.each do |column|
          count = Survey.where("#{column} = ?", true).count

          sheet.add_row [column.humanize, count]
        end
      end
    end

    def last_dental_visit
      count_sheet "Last Dental Visit", "last_dental_visit",
                  ["Last Dental Visit", "Patient Count"], Patient.unique
    end

    def needs_more_dental_care
      count_sheet "Needs More Dental Care", "told_needed_more_dental_treatment",
                  ["Needs More Dental Care?", "Patient Count"]
    end

    def has_dentist
      count_sheet "Dental Treatment",
                  "has_place_to_be_seen_for_dental_care",
                  ["Has a Place to Go For Dental Treatment?", "Patient Count"]
    end

    def count_sheet(sheet_name, column, header_row, scope = Survey)
      book.add_worksheet(:name => sheet_name) do |sheet|
        counts = scope.select("#{column}, count(*) as c").group(column).
          order(column)

        sheet.add_row header_row

        counts.each do |row|
          sheet.add_row [row.send(column), row.c]
        end
      end
    end
  end
end
