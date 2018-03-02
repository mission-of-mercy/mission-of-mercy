class Survey < ActiveRecord::Base
  HEARD_ABOUT_OPTIONS = [
    "Family member or friend",
    "Television",
    "Radio",
    "Newspaper",
    "Internet – Facebook, Twitter, Blog, or other website",
    "Doctor’s office",
    "Health center/clinic",
    "Hospital",
    "Church or other religious organization",
    "At work"
  ]

  RACE_OPTIONS = [
    "White",
    "Black or African-American",
    "Asian",
    "Native Hawaiian or other Pacific Islander",
    "American Indian or Alaska Native"
  ]

  VISIT_OPTIONS = [
    'This is a dental emergency',
    'Cannot afford to go to a dentist',
    "Don't have insurance for dental care",
    "Don't want to spend the money for dental care",
    'Cannot get an appointment soon enough with a dentist',
    'Cannot take time off work to go to a dentist',
    'Dental office is too far away',
    'Dental office is not open at convenient times',
    'Too busy to go to dental office',
    "Don't have transportation to get to dental office",
    "Don't know where to go for care",
    'Friend/family told me to come here'
  ]

  OTHER_VISIT_OPTIONS = [
    'No other reasons'
  ] + VISIT_OPTIONS.reject {|r| r == 'Other Reason' }

  TWELVE_MO_VISITED = [
    "Dentist’s office",
    "Cape Coral Hospital emergency room",
    "Golisano Children’s Hospital of Southwest Florida",
    "Gulf Coast Medical Center emergency room",
    "Health Park Medical Center emergency room",
    "Lee Memorial Hospital emergency room",
    "Lehigh Regional Medical Center emergency room",
    "Project Dentists Care (PDC) of Southwest Florida clinic",
    "Family Health Centers for Southwest Florida Downtown Ft. Myers dental clinic",
    "Florida Southwestern State College Dental Clinic",
    "Some other place",
    "Jazz hands"
  ]

  serialize :heard_about_clinic, Array
  serialize :race, Array
  serialize :other_reasons_for_visit, Array
  serialize :twelve_mo_visited, Array

  before_save :remove_blank_options

  def patient
    Patient.find_by(survey_id: id)
  end

  def update_patient_information(patient)
    %w[city state zip age sex language pain time_in_pain overall_health
      consent_to_research_study].each do |attr|
      self[attr] = patient.public_send(attr)
    end

    self.reason_for_visit = patient.chief_complaint
  end

  private

  def remove_blank_options
    self.heard_about_clinic      = heard_about_clinic.reject(&:blank?)
    self.race                    = race.reject(&:blank?)
    self.other_reasons_for_visit = other_reasons_for_visit.reject(&:blank?)
  end
end
