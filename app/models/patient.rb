class Patient < ActiveRecord::Base
  before_save :update_survey
  before_save :normalize_data
  after_create :check_in_flow
  
  has_many :patient_prescriptions, :dependent => :delete_all
  has_many :patient_procedures, :dependent => :delete_all
  has_many :patient_pre_meds, :dependent => :delete_all
  has_many :procedures, :through => :patient_procedures
  has_many :prescriptions, :through => :patient_prescriptions
  has_many :pre_meds, :through => :patient_pre_meds
  has_many :flows, :class_name => "PatientFlow"
  has_many :previous_mom_clinics, :class_name => "PatientPreviousMomClinic"
  
  has_one :prosthetic
  
  belongs_to :survey, :dependent => :delete
  belongs_to :assigned_treatment_area, :class_name => "TreatmentArea"
  
  accepts_nested_attributes_for :survey
  accepts_nested_attributes_for :patient_prescriptions, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }
    
  accepts_nested_attributes_for :patient_pre_meds, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }
                                
  accepts_nested_attributes_for :previous_mom_clinics, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['attended'] == "0" }
                                                              
  validates_presence_of :first_name, :last_name, :date_of_birth, :sex, :race, :chief_complaint, :last_dental_visit, :travel_time, :city, :state
  
  attr_accessor :race_other
  
  # Old Pagination Method ...
  def self.search(chart_number, name, page)
    conditions = if chart_number.blank? && !name.blank?
      ['first_name like ? or last_name like ?', "%#{name}%","%#{name}%"]
    elsif !chart_number.blank?
      ["id = ?", chart_number]
    else
      ["id = ?", -1]
    end
  
		paginate  :per_page => 30, :page => page,
              :conditions => conditions,
              :order => 'id'
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
  
  def check_out(area)
    unless area == TreatmentArea.radiology
      self.flows.create(:area_id => ClinicArea::CHECKOUT,
                        :treatment_area_id => area.id)
    
      self.update_attributes(:assigned_treatment_area_id => nil,
                             :survey_id => nil)
    end
  end
  
  def export_to_dexis(path)
    f = File.new(path, "w")
    f.write(["PN=", id.to_s, "\r\n"].join())
    f.write(["LN=", last_name, "\r\n"].join())
    f.write(["FN=", first_name, "\r\n"].join())
    f.write(["BD=", date_of_birth_dexis, "\r\n"].join())
    f.write(["SX=", sex].join())
    f.close
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
  
  def normalize_data
    self.race = race_other if race_other != nil and race == "Other"
    
    self.first_name.capitalize!
    self.last_name.capitalize!
  end
  
  def check_in_flow
    self.flows.create(:area_id => ClinicArea::CHECKIN)
  end
end
