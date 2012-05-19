class Treatment < ActiveRecord::Base
  validates_presence_of :name

  scope :provided, where(:provided => true)
end
