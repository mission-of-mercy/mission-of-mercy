class PatientDecorator < ApplicationDecorator
  decorates :patient

  def dob_select_options
    {
      :order         => [:month, :day, :year],
      :start_year    => (Date.today.year),
      :end_year      => 1900,
      :include_blank => true
    }
  end

  def sex_select_options
    [[["M", "M"], ["F","F"]], {:include_blank => true}]
  end

  def chief_complaint_options
    treatments = if model.new_record?
      Treatment.provided
    else
      Treatment.all
    end
    [treatments.map(&:name), {:include_blank => true}]
  end

  def last_dental_visit_options
    visits = [
                "First Time",
                "Less Than 30 Days",
                "Less Than 6 Months",
                "Greater Than 6 Months",
                "Between  1 and 2 Years",
                "2+ Years"
             ]

    [visits, {:include_blank => true}]
  end
end