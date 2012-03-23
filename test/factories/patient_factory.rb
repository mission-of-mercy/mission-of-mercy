FactoryGirl.define do
  factory :patient do
    first_name        { Faker::Name.first_name }
    last_name         { Faker::Name.last_name }
    date_of_birth     { Date.today - rand(100).years }
    sex               { %w( M F ).shuffle.first }
    race              { Patient::RACES.sample }
    chief_complaint   { "Cleaning" }
    last_dental_visit "First Time"
    travel_time       { 1 + rand(90) }
    street            { Faker::Address.street_address }
    city              { Faker::Address.city }
    state             { Faker::Address.state_abbr }
    zip               { Faker::Address.zip_code }

    # Faker::PhoneNumber includes invalid formats like "###-###-#### x###"
    phone             { Faker::PhoneNumber.phone_number.split(" ").first }

    survey
  end

  factory :survey do
    told_needed_more_dental_treatment     true
    heard_about_clinic                    "Social Media"
    has_place_to_be_seen_for_dental_care  false
    no_insurance                          true
  end
end
