FactoryGirl.define do
  factory :procedure do
    description           { Faker::Lorem.words(1 + rand(4)).join(" ").titleize }
    code                  { rand(1000) }
    requires_tooth_number false
    requires_surface_code false
    cost                  { rand(500) }
  end
end
