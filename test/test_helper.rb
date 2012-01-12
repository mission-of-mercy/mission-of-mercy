require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  module TestHelper
    extend self

    # December, 26, 1985 + a user-defined time
    def clinic_date(time=nil)
      date = "12/26/1985"

      if time
        m, d, y = date.split('/')
        Time.parse "#{[y, m, d] * '-'} #{time}"
      else
        Date.strptime(date, "%m/%d/%Y")
      end
    end

    def valid_patient
      Factory.build(:patient)
    end

    def create_test_patients(date=Date.today)
      (6..17).map { |i| date + i.hours }.each do |datetime|
        Factory.create(:patient, :created_at => datetime, :updated_at => datetime)
      end
    end

    def create_test_prescriptions
      Factory(:prescription,
              :name     => "Amoxicillin",
              :quantity => 21,
              :dosage   => "500mg",
              :cost     => 12.99,
              :strength => "1 YID x 7days")
    end

    def create_test_procedures
      Factory.create(:procedure,
              :description => "Comp. Oral Exam",
              :code        => 150,
              :cost        => 90)
      Factory.create(:procedure,
              :description => "Panoramic film",
              :code        => 330,
              :cost        => 125)
    end

    def create_test_xray(time, patient)
      Factory(:patient_flow,
              :area_id    => ::ClinicArea::XRAY,
              :patient    => patient,
              :created_at => time)
    end
  end
end

Spork.each_run do
end

# running
# $ testdrb -Itest path/to/test/file.rb
