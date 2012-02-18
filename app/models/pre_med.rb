class PreMed < ActiveRecord::Base
  require 'time_scope'
  extend TimeScope

	has_many :patient_pre_meds
end
