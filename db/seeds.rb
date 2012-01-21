require_relative 'seeds/users'
require 'highline'
require 'faker'

# Custom Settings

console = HighLine.new

if User.count.zero?

  password = console.ask("Default password for all user accounts") do |q|
    q.default = "temp123"
  end
  total_xray_stations = console.ask("Number of X-Ray Stations", Integer) do |q|
    q.default = 5
  end

  Seeds.create_users(:password => password, :xray_stations => total_xray_stations)

  puts "#{User.count} users created"
  puts "Passwords have been set to #{password.bright}".color(:red)
else
  puts "Skip: #{User.count} users already exist"
end

if TreatmentArea.count.zero?

  areas = [ { :name => "Radiology",   :capacity => 50 },
            { :name => "Hygiene",     :capacity => 50 },
            { :name => "Restoration", :capacity => 50,
                :amalgam_composite_procedures => true },
            { :name => "Pediatrics",  :capacity => 50 },
            { :name => "Endodontics", :capacity => 50 },
            { :name => "Surgery",     :capacity => 50 },
            { :name => "Prosthetics", :capacity => 15 } ]

  areas.each do |area|
    TreatmentArea.create(area)
  end

  puts "#{TreatmentArea.count} treatment areas created"
else
  puts "Skip: #{TreatmentArea.count} treatment areas already exist"
end

puts # Empty Line

create_sample_data = console.agree("Would you like to create sample data (Patients, Prescriptions, etc)?")

if create_sample_data
  Prescription.create(:name => "Amoxicillin", :strength => "500mg",
    :quantity => 21, :dosage => "1 q8h x7d")
  Prescription.create(:name => "Ibuprofen", :strength => "200mg",
    :quantity => 28, :dosage => "1-2 q 4-6h prn pain")
  Prescription.create(:name => "Tylenol", :strength => "500mg",
    :quantity => 28, :dosage => "1-2 4-6 h prn pain")
  Prescription.create(:name => "Pen VK", :strength => "500mg",
    :quantity => 28, :dosage => "1 q6h x 7d")

  puts "#{Prescription.count} prescriptions created"

  patients = []

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

    patients << patient
  end

  puts "#{Patient.count} patients created"

  patients.sample(60).each do |patient|
    patient.flows.create(:area_id => ClinicArea::XRAY)
  end

  puts "60 patients visited Radiology"

  treatment_areas = TreatmentArea.where("name <> 'Radiology'").all
  procedures      = Procedure.all

  patients.sample(50).each do |patient|
    (rand(procedures.count) + 1).to_i.times do
      patient.patient_procedures.create(:procedure => procedures.sample,
        :surface_code => "FLOMDIB".chars.to_a.sample,
        :tooth_number => "ABCDEFGHIJK123456789".chars.to_a.sample)
    end
    patient.check_out(treatment_areas.sample)
  end

  puts "50 patients checked out of the clinic"

  prescriptions = Prescription.all

  patients.sample(40).each do |patient|
    (rand(prescriptions.length) + 1).times do
      patient.patient_prescriptions.create(:prescription => prescriptions.sample)
    end
    patient.flows.create(:area_id => ClinicArea::PHARMACY)
  end

  puts "40 patients were given prescriptions"

end
