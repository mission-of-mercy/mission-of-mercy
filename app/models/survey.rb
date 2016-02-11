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

  def update_patient_information(patient)
    %w[city state zip age sex language ].each do |attr|
      self[attr] = patient.public_send(attr)
    end
  end
end
