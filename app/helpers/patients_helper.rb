module PatientsHelper
  def link_to_checkout(area, patient)
    if area == TreatmentArea.radiology
      radiology_link(patient)
    else
      name = TreatmentArea.find(area).name
      link_to "#{name} Checkout", checkout_path(area, patient), class: 'primary'
    end
  end

  def show_previous_mom(patient)
    "display:none;" unless patient.attended_previous_mom_event
  end

  def yes_no_group(f, attribute, options = {})
    [
      f.radio_button(attribute, true, options),
      f.label(attribute, "Yes", :value => true),
      f.radio_button(attribute, false, options),
      f.label(attribute, "No", :value => false)
    ].join("\n").html_safe
  end

  def languages
    [
      "Spanish or Spanish Creole",
      "Portuguese or Portuguese Creole",
      "French",
      "Italian",
      "Mon-Khmer, Cambodian",
      "Vietnamese",
      "French Creole",
      "Chinese",
      "Laotian",
      "Hmung",
      "Polish",
      "German",
      "African languages",
      "Arabic",
      "Other"
    ]
  end
end
