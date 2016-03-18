require 'faker'

FactoryGirl.define do
  factory :heard_about_clinic do |f|
    f.sequence(:reason) { |n| "Heard about Clinic \##{n}" }
  end

  factory :patient_assignment do
    patient
    treatment_area
  end

  factory :patient do
    transient do
      zipcode { Patient::Zipcode.all.sample || FactoryGirl.create(:zipcode) }
    end

    first_name        { Faker::Name.first_name }
    last_name         { Faker::Name.last_name }
    date_of_birth     { Date.today - rand(100).years }
    sex               { %w( M F ).shuffle.first }
    race              { "Caucasian/White" }
    chief_complaint   { "Cleaning" }
    last_dental_visit { "First Time" }
    travel_time       { 1 + rand(90) }
    pain              { [true, false].sample }
    street            { Faker::Address.street_address }
    city              { Faker::Address.city }
    zip               { zipcode.zip }
    state             { zipcode.state }
    county            { zipcode.county }
    chart_printed     true
    language          "English"
    overall_health    "Excellent"

    # Faker::PhoneNumber includes invalid formats like "1-###-###-#### x###"
    phone { Faker::PhoneNumber.phone_number.split(" ").first.gsub(/\A1-/, '') }

    survey
  end

  factory :zipcode, class: 'Patient::Zipcode' do
    zip    '06410'
    city   'Cheshire'
    state  'CT'
    county 'New Haven'
  end

  factory :survey do
    told_needed_more_dental_treatment true
    heard_about_clinic                { ["Social Media"] }
    race                              { ["Caucasian/White"] }
    language                          "English"
  end

  factory :patient_flow do |pf|
    pf.area_id       { 1 + rand(5) }
    pf.association   :patient
    pf.created_at    { Time.current.utc }

    factory :patient_check_in do
      area_id ClinicArea::CHECKIN
    end

    factory :patient_check_out do
      area_id ClinicArea::CHECKOUT
    end
  end

  factory :prescription do
    daily_dose = 1 + Kernel.rand(3)
    days       = [5, 7, 10, 14].shuffle.first

    name      { Faker::Lorem.words(1 + rand(2)).join(" ").titlecase }
    cost      { 3 + rand(25) - 0.01 }
    dosage    { "#{ (1 + rand(5)) * 100 } mg" }
    quantity  { daily_dose * days }
    strength  { "#{ daily_dose } TID x #{ days } days" }
  end

  factory :patient_prescription do
    prescribed true
    patient
    prescription
  end

  factory :procedure do
    description           { Faker::Lorem.words(1 + rand(4)).join(" ").titleize }
    sequence(:code)       { |n| n }
    requires_tooth_number false
    requires_surface_code false
    cost                  { rand(500) }
  end

  factory :race do |f|
    f.sequence(:category) { |n| "Race \##{n}" }
  end

  factory :treatment_area do |f|
    f.sequence(:name) { |n| "Area ##{n}" }
    capacity          20
  end

  factory :procedure_treatment_area_mapping do
    assigned true
    treatment_area
    procedure
  end

  factory :treatment do |f|
    f.sequence(:name) { |n| "Treatment \##{n}" }
  end

  factory :user do
    login 'check_in'
    user_type UserType::CHECKIN
    password 'temp123'
    password_confirmation 'temp123'
  end

  factory :patient_previous_mom_clinic do
    clinic_year 2009
    location    'New Haven'
    attended    true
    patient
  end

  factory :support_request do
    user_id    { User.first.try(:id) }
    ip_address "123.123.123.123"
    resolved   false
  end
end
