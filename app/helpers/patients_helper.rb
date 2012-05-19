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
end
