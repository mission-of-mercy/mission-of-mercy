class HeardAboutClinicDecorator < ApplicationDecorator
  decorates :heard_about_clinic

  def self.options_for_select
    [ HeardAboutClinic.all.map(&:reason), { :include_blank => true} ]
  end
end