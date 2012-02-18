class PreMed < ActiveRecord::Base
  extend TimeScope

	has_many :patient_pre_meds
end
