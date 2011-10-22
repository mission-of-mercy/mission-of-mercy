class User < ActiveRecord::Base
  devise :database_authenticatable
  
  attr_accessible :login,:password, :password_confirmation
end
