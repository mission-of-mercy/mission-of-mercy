require 'highline'
require 'faker'

# Custom Settings

console = HighLine.new

password = console.ask("Default password for all user accounts") do |q|
  q.default = "temp123"
end
total_xray_stations = console.ask("Number of X-Ray Stations", Integer) do |q|
  q.default = 5
end

# Users

users = [ { :login => "admin",           :user_type => UserType::ADMIN },
          { :login => "check_in",        :user_type => UserType::CHECKIN },
          { :login => "check_out",       :user_type => UserType::CHECKOUT },
          { :login => "assignment_desk", :user_type => UserType::ASSIGNMENT },
          { :login => "pharmacy",        :user_type => UserType::PHARMACY } ]

(1..total_xray_stations).each do |id|
  users << { :login      => "xray_#{id}",
             :user_type  => UserType::XRAY,
             :station_id => id }
end

users.each do |user|
  User.create( :login                  => user[:login],
               :user_type              => user[:user_type],
               :password               => password,
               :password_confirmation  => password,
               :x_ray_station_id       => user[:station_id] )
end

puts "#{User.count} users created"
puts "Passwords have been set to #{password.bright}".color(:red)

# Treatment Areas

areas = [ { :name => "Radiology",   :capacity => 50 },
          { :name => "Hygiene",     :capacity => 50 },
          { :name => "Restoration", :capacity => 50,
              :amalgam_composite_procedures => true },
          { :name => "Pediatrics",  :capacity => 50 },
          { :name => "Endodontics", :capacity => 50 },
          { :name => "Surgery",     :capacity => 50 },
          { :name => "Prosthetics", :capacity => 15 } ]

areas.each do |area|
  TreatmentArea.create(area)
end

puts "#{TreatmentArea.count} treatment areas created"

sample_patients = console.agree("Would you like to create sample patient data?")

if sample_patients
  50.times do
    Patient.create(
      :first_name        => Faker::Name.first_name,
      :last_name         => Faker::Name.last_name,
      :date_of_birth     => Date.today - rand(100).years,
      :sex               => %w( M F ).shuffle.first,
      :race              => Faker::Lorem.words(2).join(" ").titlecase,
      :chief_complaint   => Faker::Lorem.sentence(rand(7)),
      :last_dental_visit => "today",
      :travel_time       => 1 + rand(90),
      :street            => Faker::Address.street_address,
      :city              => Faker::Address.city,
      :state             => Faker::Address.state_abbr,
      :zip               => Faker::Address.zip_code,
      :phone             => Faker::PhoneNumber.phone_number.split(" ").first
    )
  end

  puts "#{Patient.count} patients created"
end