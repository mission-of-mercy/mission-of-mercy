class Patient < ActiveRecord::Base
  before_validation :normalize_data
  before_save  :update_survey
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
  has_many :assignments,           :class_name  => 'PatientAssignment',
                                   :dependent   => :delete_all
  has_many :treatment_areas,       :through     => :assignments

  has_one :zipcode,                :class_name  => "Patient::Zipcode",
                                   :foreign_key => "zip",
                                   :primary_key => "zip"

  belongs_to :survey,              :dependent  => :delete

  accepts_nested_attributes_for :survey
  accepts_nested_attributes_for :patient_prescriptions, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }

  accepts_nested_attributes_for :patient_pre_meds, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['prescribed'] == "0" }

  accepts_nested_attributes_for :previous_mom_clinics, :allow_destroy => true,
                                :reject_if => proc { |attributes| attributes['attended'] == "0" }

  validate              :date_of_birth_entry
  validates_length_of   :zip,   :maximum => 10, :allow_blank => true
  validates_length_of   :state, :maximum => 2
  validates_presence_of :first_name, :last_name, :sex, :language,
                        :city, :state
  validates_format_of   :phone, :message     => "must be a valid telephone number.",
                                :with        => /\A[\(\)0-9\- \+\.]{10,20}\z/,
                                :allow_blank => true

  def self.unique
    where(:previous_chart_number => nil)
  end

  def self.created_today
    where("patients.created_at::Date = ?", Date.today)
  end

  def chart_number
    id
  end

  def full_name
    [first_name,last_name].join(' ')
  end

  def age
    (Date.today - date_of_birth).to_i / 365
  end

  def contact_information
    { :phone => phone, :street => street, :zip => zip,
      :city => city,   :state => state }
  end

  def dob
    date_of_birth.strftime("%m/%d/%Y") if date_of_birth
  end

  def date_of_birth_dexis
    date_of_birth.strftime("%d.%m.%Y") if date_of_birth
  end

  def procedures_grouped
    patient_procedures.group_by(&:procedure)
  end

  def check_out(area)
    return unless area

    to_check_out = if area.radiology?
      self.flows.create(area_id: ClinicArea::XRAY)

      assignments.where(treatment_area_id: area.id).not_checked_out
    else
      self.flows.create(area_id: ClinicArea::CHECKOUT, treatment_area_id: area.id)

      assignments.not_checked_out
    end

    to_check_out.each {|assignment| assignment.check_out }
  end

  def checked_out?
    flows.where(area_id: ClinicArea::CHECKOUT).any?
  end

  def assign(area_id, radiology)
    radiology_assignment = assignments.not_checked_out.radiology

    if radiology
      unless radiology_assignment.any?
        radiology_assignment.create(:treatment_area_id => TreatmentArea.radiology.id)
      end
    else
      radiology_assignment.first.destroy if radiology_assignment.first
    end

    assigned_treatment_area = TreatmentArea.find_by_id(area_id)

    current_assignment = assignments.not_checked_out.radiology(false).first

    if assigned_treatment_area &&
      ( current_assignment.nil? ||
        current_assignment.treatment_area != assigned_treatment_area )

      current_assignment.destroy if current_assignment
      assignments.create(:treatment_area_id => assigned_treatment_area.id)
    end

    true # Everything is just fine
  end

  def assigned_to
    assignments.not_checked_out.map(&:treatment_area)
  end

  def assigned_to?(area)
    assigned_to.include?(area)
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

  def date_of_birth=(date_of_birth)
    if date_of_birth.is_a?(String)
      @date_string = date_of_birth

      month, day, year = @date_string.split(/[-.\/]/).map(&:to_i)

      year = nil if year.to_s.length != 4

      self[:date_of_birth] = Date.civil(year, month, day) rescue nil
    elsif @date_string.blank?
      super
    end
  end

  def build_previous_mom_clinics
    PreviousClinic.order("year").each do |clinic|
      existing = self.previous_mom_clinics.detect do |c|
        c.clinic_year == clinic.year && c.location == clinic.location
      end

      unless existing
        self.previous_mom_clinics.build(clinic_year: clinic.year,
                                        location: clinic.location)
      end
    end
  end

  # All charts that came before or after this chart
  #
  def associated_charts
    @associated_charts ||= begin
      patients = []
      # Forward
      next_patient = ->(id) { Patient.where(previous_chart_number: id).first }
      id = self.id
      while(next_patient[id].present?)
        patients << next_patient[id]
        id = patients.last.id
      end
      # Backward
      previous_id = previous_chart_number
      previous_patient = ->(id) { Patient.where(id: id).first }
      while(previous_patient[previous_id].present?)
        patients << previous_patient[previous_id]
        previous_id = patients.last.previous_chart_number
      end

      patients.sort_by(&:id)
    end
  end

  private

  def update_survey
    return if previous_chart_number.present?

    survey.update_patient_information(self) if survey
  end

  def normalize_data
    self.first_name.capitalize!
    self.last_name.capitalize!
    self.state.upcase!
  end

  def check_in_flow
    self.flows.create(:area_id => ClinicArea::CHECKIN)
  end

  def date_of_birth_entry
    if self.date_of_birth.nil?
      if @date_string.blank?
        errors.add(:date_of_birth, "can't be blank")
      else
        errors.add(:date_of_birth, "must be in a valid format (mm/dd/yyyy, mm-dd-yyyy)")
        self[:date_of_birth] = @date_string
      end
      return false
    else
      if age < 0 || age > 122 # Oldest person alive
        errors.add(:date_of_birth, "is invalid. Patient can't be #{age} years old")
        return false
      end
    end

    return true
  end

end
