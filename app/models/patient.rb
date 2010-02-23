class Patient < ActiveRecord::Base
  has_many :patient_prescriptions
  has_many :patient_procedures 
  has_many :procedures, :through => :patient_procedures
  has_many :prescriptions, :through => :patient_prescriptions
  
  accepts_nested_attributes_for :patient_procedures
  
  validates_presence_of :first_name, :last_name, :date_of_birth, :sex, :race, :chief_complaint, :last_dental_visit, :travel_time, :city, :state

  def self.time_zone_aware_attributes
   false
  end
  
  # Old Pagination Method ...
  def self.search(chart_number,name,page)
    conditions = ['id = ?', "#{chart_number}"]
  
    if (chart_number == nil || chart_number == "") && (name != nil && name != "")
      conditions = ['first_name like ? or last_name like ?', "%#{name}%","%#{name}%"]
    end
  
		paginate  :per_page => 30, :page => page,
              :conditions => conditions,
              :order => 'id'
              
    # or last_name like ? or first_name like ?,"%#{name}%","%#{name}%"
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
  
  def procedures_grouped
    patient_procedures.group_by(&:procedure)
  end
end
