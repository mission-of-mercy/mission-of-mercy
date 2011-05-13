# Users

default_password = "temp123"
total_xray_stations = 5

users = [ {:login => "admin", :user_type => UserType::ADMIN},
          {:login => "check_in", :user_type => UserType::CHECKIN},
          {:login => "check_out", :user_type => UserType::CHECKOUT},
          {:login => "assignment_desk", :user_type => UserType::ASSIGNMENT},
          {:login => "pharmacy", :user_type => UserType::PHARMACY}]
          
(1..total_xray_stations).each do |id|
  users << {  :login      => "xray_#{id}", 
              :user_type  => UserType::XRAY,
              :station_id => id}
end

users.each do |user|
  User.create(  :login                  => user[:login], 
                :user_type              => user[:user_type], 
                :password               => default_password, 
                :password_confirmation  => default_password,
                :x_ray_station_id       => user[:station_id] )
end

# Treatment Areas

areas = [ {:name => "Radiology", :capacity => 50},
          {:name => "Hygiene", :capacity => 50},
          {:name => "Restoration", :capacity => 50, :amalgam_composite_procedures => true},
          {:name => "Pediatrics", :capacity => 50},
          {:name => "Endodontics", :capacity => 50},
          {:name => "Surgery", :capacity => 50},
          {:name => "Prosthetics", :capacity => 15}]

areas.each do |area|
  TreatmentArea.create(area)
end