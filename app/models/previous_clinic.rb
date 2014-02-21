class PreviousClinic < ActiveRecord::Base
  validates_presence_of :year, :location

  def description
    "#{year} #{location}"
  end
end
