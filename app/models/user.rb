class User < ActiveRecord::Base
  devise :database_authenticatable

  attr_accessible :password, :password_confirmation, :login, :user_type, :station_id
  
  def start_path
    #temporary hack because I don't know where is the start_path defined. Maybe it is a restful_authentication specific variable from old times
    #tried to use root_path but it isn't working for some reason
    '/'
  end
end
