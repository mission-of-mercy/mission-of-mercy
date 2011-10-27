class Patient::Zipcode < ActiveRecord::Base
  before_create :pad_zip

  validates_presence_of :zip

  private

  def pad_zip
    self.zip = ("%05d" % self.zip) if Integer === self.zip
  end

end
