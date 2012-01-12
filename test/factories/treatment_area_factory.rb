FactoryGirl.define do
  factory :treatment_area do |f|
    f.sequence(:name) { |n| "Area \##{n}" }
    capacity          20
  end
end
