class Survey < ActiveRecord::Base
  before_save :heard_about_save

  attr_accessor :heard_about_other

  private

  def heard_about_save
    self.heard_about_clinic = heard_about_other unless heard_about_other.blank?
  end
end
