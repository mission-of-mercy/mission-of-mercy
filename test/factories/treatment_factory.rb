FactoryGirl.define do
  factory :treatment do |f|
    f.sequence(:name) { |n| "Treatment \##{n}" }
  end
end
