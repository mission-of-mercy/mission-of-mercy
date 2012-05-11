module SurveysHelper
  def heard_about_clinic_options
    [ HeardAboutClinic.all_reasons, { :include_blank => true} ]
  end
end
