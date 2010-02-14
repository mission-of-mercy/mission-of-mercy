class Patient < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :date_of_birth, :sex, :race, :chief_complaint, :last_dental_visit, :travel_time, :city, :state

  def self.time_zone_aware_attributes
   false
  end
  
  def chart_number
    id
  end

  def full_name
    [first_name,last_name].join(' ')
  end
  
  def age
    today = DateTime.now
    age = today - date_of_birth
    age.to_i / 365
  end
  
  def dob
    date_of_birth.strftime("%m/%d/%Y")
  end
  
  def date_of_birth_dexis
    date_of_birth.strftime("%d.%m.%Y")
  end
end
