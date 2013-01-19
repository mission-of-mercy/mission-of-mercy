require 'faker'

namespace :db do

  desc 'generates sample clinic data'
  setup_task :sample => :environment do

    unless Prescription.any?
      Prescription.create(:name => "Amoxicillin", :strength => "500mg",
        :quantity => 21, :dosage => "1 q8h x7d")
      Prescription.create(:name => "Ibuprofen", :strength => "200mg",
        :quantity => 28, :dosage => "1-2 q 4-6h prn pain")
      Prescription.create(:name => "Tylenol", :strength => "500mg",
        :quantity => 28, :dosage => "1-2 4-6 h prn pain")
      Prescription.create(:name => "Pen VK", :strength => "500mg",
        :quantity => 28, :dosage => "1 q6h x 7d")

      done "#{Prescription.count} prescriptions created"
    end

    if Patient.count < 100
      100.times do
        patient = Patient.new(
          :first_name        => Faker::Name.first_name,
          :last_name         => Faker::Name.last_name,
          :date_of_birth     => Date.today - rand(100).years,
          :sex               => %w( M F ).shuffle.first,
          :race              => Faker::Lorem.words(2).join(" ").titlecase,
          :chief_complaint   => Faker::Lorem.sentence(rand(7)),
          :last_dental_visit => "today",
          :travel_time       => 1 + rand(90),
          :street            => Faker::Address.street_address,
          :city              => Faker::Address.city,
          :state             => Faker::Address.state_abbr,
          :zip               => Faker::Address.zip_code,
          :phone             => Faker::PhoneNumber.phone_number.split(" ").first
        )

        patient.survey = Survey.new
        patient.save
      end
    end

    done "#{Patient.count} patients created"

    patients = Patient.all

    patients.sample(60).each do |patient|
      patient.flows.create(:area_id => ClinicArea::XRAY)
    end

    done "60 patients visited Radiology"

    unless Procedure.any?
      Rake::Task["procedures:import"].invoke
    end

    treatment_areas = TreatmentArea.where("name <> 'Radiology'").all
    procedures      = Procedure.all

    patients.sample(50).each do |patient|
      rand(1..10).times do
        patient.patient_procedures.create(:procedure => procedures.sample,
          :surface_code => "FLOMDIB".chars.to_a.sample,
          :tooth_number => "ABCDEFGHIJK123456789".chars.to_a.sample)
      end
      patient.check_out(treatment_areas.sample)
    end

    done "50 patients checked out of the clinic"

    prescriptions = Prescription.all

    patients.sample(40).each do |patient|
      (rand(prescriptions.length) + 1).times do
        patient.patient_prescriptions.create(:prescription => prescriptions.sample)
      end
      patient.flows.create(:area_id => ClinicArea::PHARMACY)
    end

    done "40 patients were given prescriptions"

  end

end