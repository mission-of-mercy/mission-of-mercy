FactoryGirl.define do
  factory :prescription do
    daily_dose = 1 + Kernel.rand(3)
    days       = [5, 7, 10, 14].shuffle.first

    name      { Faker::Lorem.words(1 + rand(2)).join(" ").titlecase }
    cost      { 3 + rand(25) - 0.01 }
    dosage    { "#{ (1 + rand(5)) * 100 } mg" }
    quantity  { daily_dose * days }
    strength  { "#{ daily_dose } TID x #{ days } days" }
  end
end
