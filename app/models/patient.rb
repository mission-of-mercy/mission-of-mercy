class Patient < ActiveRecord::Base
  before_save :update_survey
  before_create :previous_mom_legacy
  after_create :check_in_flow
  
  has_many :patient_prescriptions, :dependent => :delete_all
  has_many :patient_procedures, :dependent => :delete_all
  has_many :patient_pre_meds, :dependent => :delete_all
  has_many :procedures, :through => :patient_procedures
  has_many :prescriptions, :through => :patient_prescriptions
  has_many :pre_meds, :through => :patient_pre_meds
  has_many :flows, :class_name => "PatientFlow"
  has_many :previous_mom_clinics, :class_name => "PatientPreviousMomClinic"
  
  belongs_to :survey, :dependent => :delete
  belongs_to :assigned_treatment_area, :class_name => "TreatementArea"
  
  accepts_nested_attributes_for :survey
  accepts_nested_attributes_for :patient_prescriptions, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }
    
  accepts_nested_attributes_for :patient_pre_meds, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }
                                
  accepts_nested_attributes_for :previous_mom_clinics, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['attended'] == "0" }
                                                              
  validates_presence_of :first_name, :last_name, :date_of_birth, :sex, :race, :chief_complaint, :last_dental_visit, :travel_time, :city, :state
  
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
  
  private
  
  def update_survey
    if self.survey
      self.survey.city                = city
      self.survey.state               = state
      self.survey.zip                 = zip
      self.survey.age                 = age
      self.survey.sex                 = sex
      self.survey.race                = race
      self.survey.pain                = pain
      self.survey.pain_length_in_days = pain_length_in_days 
    end
  end
  
  def check_in_flow
    self.flows.create(:area_id => ClinicArea::CHECKIN)
  end
  
  def previous_mom_legacy
    self.previous_mom_event_location = self.previous_mom_clinics.map{|c| c.description }.join(" and ")
  end
end
