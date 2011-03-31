class User::Zipcode < ActiveRecord::Base
  before_create :pad_zip
  
  private
  
  def pad_zip
    self.zip = ("%05d" % self.zip)
  end

end
