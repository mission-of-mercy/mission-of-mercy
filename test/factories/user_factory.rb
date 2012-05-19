FactoryGirl.define do
  factory :user do
    login 'check_in'
    user_type UserType::CHECKIN
    password 'temp123'
    password_confirmation 'temp123'
  end
end
