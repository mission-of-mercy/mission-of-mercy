module PatientsHelper
  def link_to_checkout(area, patient)
    name = TreatmentArea.find(area).name

    link_to "#{name} Checkout", checkout_path(area,patient)
  end

  def show_previous_mom(patient)
    "display:none;" unless patient.attended_previous_mom_event
  end

  def yes_no_group(f, attribute)
    [
      f.radio_button(attribute, true),
      f.label(attribute, "Yes", :value => true),
      f.radio_button(attribute, false),
      f.label(attribute, "No", :value => false)
    ].join("\n").html_safe
  end

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

  def race_select_options
    [ Patient::RACES, { :include_blank => true} ]
  end

  def chief_complaint_options(f)
    treatments = if @patient.new_record?
      Treatment.provided_names
    else
      Treatment.all_names
    end
    [treatments, {:include_blank => true}]
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
