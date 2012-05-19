FactoryGirl.define do
  factory :race do |f|
    f.sequence(:category) { |n| "Race \##{n}" }
  end
end
