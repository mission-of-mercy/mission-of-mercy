FactoryGirl.define do
  factory :treatment_area do |f|
    f.sequence(:name) { |n| "Area ##{n}" }
    capacity          20
  end

  factory :procedure_treatment_area_mapping do
    treatment_area
    procedure
  end
end
