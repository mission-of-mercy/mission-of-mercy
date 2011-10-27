module PatientsHelper
  def link_to_checkout(area, patient)
    name = TreatmentArea.find(area).name

    link_to "#{name} Checkout", checkout_path(area,patient), :title => "Right click to change treatment area"
  end

  def show_previous_mom(patient)
    "display:none;" unless patient.attended_previous_mom_event
  end

  def print_patient_chart
    if @last_patient
      %{MoM.openInBackground('#{print_chart_path(@last_patient)}');
        Modalbox.show($('last_patient'), {title: "Patient\'s Chart Number", width: 300});}
    end
  end

  def yes_no_group(f, attribute, onchange)
    [
      f.radio_button(attribute, true, :onchange => onchange),
      f.label(attribute, "Yes", :value => true),
      f.radio_button(attribute, false, :onchange => onchange),
      f.label(attribute, "No", :value => false)
    ].join("\n")
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
    races = [
              "African American/Black",
              "American Indian/Alaska Native",
              "Asian/Pacific Islander",
              "Caucasian/White",
              "Hispanic",
              "Indian",
              "Other"
            ]
    [ races, { :include_blank => true}, {:onchange => "MoM.Helpers.toggleOtherRace();"}]
  end

  def chief_complaint_options
     [["Filling",  "Cleaning", "Extraction"], {:include_blank => true}]
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
