class Treatment < ActiveRecord::Base

  validates_presence_of :name

  def self.all_names
    all.map(&:name)
  end

  def self.provided_names
    where(:provided => true).map(&:name)
  end

end
