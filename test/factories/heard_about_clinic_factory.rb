FactoryGirl.define do
  factory :heard_about_clinic do |f|
    f.sequence(:reason) { |n| "Heard about Clinic \##{n}" }
  end
end
