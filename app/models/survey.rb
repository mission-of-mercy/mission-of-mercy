class Survey < ActiveRecord::Base
  attr_reader :heard_about_other

  def update_patient_information(patient)
    %w[city state zip age sex race pain pain_length_in_days].each do |attr|
      self[attr] = patient.public_send(attr)
    end
  end

  def heard_about_other=(other)
    self.heard_about_clinic = other unless other.blank?
  end
end
