module Seeds
  extend self

  def create_users(params)
    password            = params[:password]
    total_xray_stations = params[:xray_stations]

    users = [ { :login => "admin",           :user_type => UserType::ADMIN },
              { :login => "check_in",        :user_type => UserType::CHECKIN },
              { :login => "check_out",       :user_type => UserType::CHECKOUT },
              { :login => "assignment_desk", :user_type => UserType::ASSIGNMENT },
              { :login => "pharmacy",        :user_type => UserType::PHARMACY } ]

    (1..total_xray_stations).each do |id|
      users << { :login            => "xray_#{id}",
                 :user_type        => UserType::XRAY,
                 :x_ray_station_id => id }
    end

    users.each do |user|
      User.create( :login                  => user[:login],
                   :user_type              => user[:user_type],
                   :password               => password,
                   :password_confirmation  => password,
                   :x_ray_station_id       => user[:x_ray_station_id] )
    end
  end
end
