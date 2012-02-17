class Treatment < ActiveRecord::Base

  validates_presence_of :name

  def self.all_names
    all.map(&:name)
  end

end
