FactoryGirl.define do
  factory :patient_assignment do
    patient
    treatment_area
    checked_out_at { Date.today }
  end
end
