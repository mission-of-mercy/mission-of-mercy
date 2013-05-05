class HeardAboutClinicDecorator < ApplicationDecorator
  decorates :heard_about_clinic

  def self.options_for_select
    reasons = HeardAboutClinic.all.map(&:reason) +
              Survey.select('DISTINCT heard_about_clinic').
                where(%{heard_about_clinic IS NOT NULL AND
                        heard_about_clinic <> ''}).
                order("heard_about_clinic").
                map(&:heard_about_clinic)

    reasons.sort!

    other_option = reasons.delete("Other")

    # Keep "Other" at the bottom of the list
    #
    if other_option
      reasons << other_option
    end

    [reasons.uniq, include_blank: true]
  end
end
