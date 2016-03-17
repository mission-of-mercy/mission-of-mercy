class Patient::Zipcode < ActiveRecord::Base
  before_validation :pad_zip

  validates_presence_of   :zip
  validates_uniqueness_of :zip

  def self.states
    select("state").order("state").pluck(:state).uniq
  end

  def self.counties_for_state(state)
    select("county").order("county").where(state: state).pluck(:county).uniq
  end

  private

  def pad_zip
    self.zip = ("%05d" % self.zip) if Integer === self.zip
  end
end
