## Users

default_password = "temp123"
total_xray_stations = 5

users = [ {:login => "admin", :user_type => UserType::ADMIN},
          {:login => "check_in", :user_type => UserType::CHECKIN},
          {:login => "check_out", :user_type => UserType::CHECKOUT},
          {:login => "assignment_desk", :user_type => UserType::ASSIGNMENT},
          {:login => "pharmacy", :user_type => UserType::PHARMACY}]
          
(1..total_xray_stations).each do |id|
  users << {  :login      => "xray_#{if}", 
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

## Treatment Area

areas = [ {:name => "Radiology", :capacity => 50, :amalgam_composite_procedures => false},
          {:name => "Hygiene", :capacity => 50, :amalgam_composite_procedures => false},
          {:name => "Restoration", :capacity => 50, :amalgam_composite_procedures => false},
          {:name => "Pediatrics", :capacity => 50, :amalgam_composite_procedures => false},
          {:name => "Endodontics", :capacity => 50, :amalgam_composite_procedures => false},
          {:name => "Surgery", :capacity => 50, :amalgam_composite_procedures => false}]

areas.each do |area|
  TreatementArea.create(area)
end