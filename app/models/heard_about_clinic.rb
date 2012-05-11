class HeardAboutClinic < ActiveRecord::Base
  validates_presence_of :reason

  def self.all_reasons
    all.map(&:reason)
  end
end
