class User < ActiveRecord::Base
  devise :database_authenticatable

  attr_accessible :password, :password_confirmation
end
