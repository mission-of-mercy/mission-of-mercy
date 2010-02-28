class TreatementArea < ActiveRecord::Base
  has_many :procedures
  has_many :patients, :foreign_key => "assigned_treatment_area_id"
end
