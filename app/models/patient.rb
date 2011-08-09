class Patient < ActiveRecord::Base
  TIME_IN_PAIN = {
    1 => /\A(\d*\.?\d*)([dwmy])\Z/,
    2 => /\Adays\Z|\Aweeks\Z|\Amonths\Z|\Ayears\Z/
  }

  before_save  :update_survey
  before_save  :normalize_data
  after_create :check_in_flow

  has_many :patient_prescriptions, :dependent   => :delete_all
  has_many :patient_procedures,    :dependent   => :delete_all
  has_many :patient_pre_meds,      :dependent   => :delete_all
  has_many :procedures,            :through     => :patient_procedures
  has_many :prescriptions,         :through     => :patient_prescriptions
  has_many :pre_meds,              :through     => :patient_pre_meds
  has_many :flows,                 :class_name  => "PatientFlow",
                                   :dependent   => :delete_all
  has_many :previous_mom_clinics,  :class_name  => "PatientPreviousMomClinic",
                                   :dependent   => :delete_all

  has_one :prosthetic,             :dependent   => :delete
  has_one :zipcode,                :class_name  => "Patient::Zipcode",
                                   :foreign_key => "zip",
                                   :primary_key => "zip"

  belongs_to :survey,              :dependent  => :delete
  belongs_to :assigned_treatment_area, :class_name => "TreatmentArea"

  accepts_nested_attributes_for :survey
  accepts_nested_attributes_for :prosthetic
  accepts_nested_attributes_for :patient_prescriptions, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }

  accepts_nested_attributes_for :patient_pre_meds, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }

  accepts_nested_attributes_for :previous_mom_clinics, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['attended'] == "0" }

  validate              :time_in_pain_format
  validates_length_of   :zip,   :maximum => 10, :allow_blank => true
  validates_length_of   :state, :maximum => 2
  validates_presence_of :first_name, :last_name, :date_of_birth, :sex, :race,
                        :chief_complaint, :last_dental_visit, :travel_time,
                        :city, :state
  validates_format_of   :phone, :message     => "must be a valid telephone number.",
                                :with        => /^[\(\)0-9\- \+\.]{10,20}$/,
                                :allow_blank => true
  validates_numericality_of :travel_time, :greater_than => 0
  attr_accessor :race_other
  attr_reader   :time_in_pain

  # Old Pagination Method ...
  def self.search(chart_number, name, page)
    conditions = if chart_number.blank? && !name.blank?
      ['first_name ILIKE ? or last_name ILIKE ?', "%#{name}%","%#{name}%"]
    elsif !chart_number.blank? && chart_number.to_i != 0
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
                             :survey_id                  => nil,
                             :radiology                  => false)
    end
  end

  def export_to_dexis(path)
    f = File.new(path, "w")
    f.write(["PN=", "#{Date.today.year}#{id}", "\r\n"].join())
    f.write(["LN=", last_name, "\r\n"].join())
    f.write(["FN=", first_name, "\r\n"].join())
    f.write(["BD=", date_of_birth_dexis, "\r\n"].join())
    f.write(["SX=", sex].join())
    f.close
  end

  def travel_time_hours=(hours)
    @travel_time_hours = hours.to_i

    calculate_travel_time
  end

  def travel_time_hours
    @travel_time_hours ||= 0
  end

  def travel_time_minutes=(minutes)
    @travel_time_minutes = minutes.to_i

    calculate_travel_time
  end

  def travel_time_minutes
    @travel_time_minutes ||= 0
  end

  def time_in_pain=(time_in_pain)
    @time_in_pain = time_in_pain
    time_in_pain  = time_in_pain.split(" ")

    if time_in_pain.length == 2
      number, type = *time_in_pain
      type = type.pluralize.downcase

      if type =~ TIME_IN_PAIN[2]
        self.pain_length_in_days = (number.to_f.send(type) / 1.day)
      end
    elsif time_in_pain.length == 1
      time_in_pain = time_in_pain.first

      if time_in_pain =~ TIME_IN_PAIN[1]
        number, type = TIME_IN_PAIN[1].match(time_in_pain).captures

        type = case type
        when "d" then "days"
        when "w" then "weeks"
        when "m" then "months"
        when "y" then "years"
        else
          nil
        end

        self.pain_length_in_days = (number.to_i.send(type) / 1.day) unless type.nil?
      elsif time_in_pain =~ /\A\d*\Z/
        self.pain_length_in_days = time_in_pain
      end
    end
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

  def time_in_pain_format
    error_message = "must be in a valid format (1 day, 1w, 5 years)"

    unless @time_in_pain.blank?
      time_in_pain = @time_in_pain.split(" ")

      if time_in_pain.length == 2
        number, type = *time_in_pain
        type = type.pluralize.downcase

        unless type =~ TIME_IN_PAIN[2]
          errors.add(:time_in_pain, error_message)
          return false
        end
      elsif time_in_pain.length == 1
        time_in_pain = time_in_pain.first

        if !(time_in_pain =~ TIME_IN_PAIN[1]) && !(time_in_pain =~ /\A\d*\Z/)
          errors.add(:time_in_pain, error_message)
          return false
        end
      else
        errors.add(:time_in_pain, error_message)
        return false
      end
    end

    return true
  end

  def calculate_travel_time
    self.travel_time = travel_time_minutes + (travel_time_hours * 60)
  end
end
