FactoryGirl.define do
  factory :patient_flow do |pf|
    pf.area_id       { 1 + rand(5) }
    pf.association   :patient
    pf.created_at    { Time.current.utc }
  end
end
