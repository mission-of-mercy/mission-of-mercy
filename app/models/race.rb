class Race < ActiveRecord::Base
  validates_presence_of :category
end
