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

  serialize :heard_about_clinic, Array
  serialize :race, Array

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
    self.heard_about_clinic = heard_about_clinic.reject(&:blank?)
    self.race               = race.reject(&:blank?)
  end
end
