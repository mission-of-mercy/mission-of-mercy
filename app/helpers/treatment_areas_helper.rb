module TreatmentAreasHelper
  def has?(patient, procedure)
    patient.procedures.include?(procedure)
  end

  def procedure_radio(procedure, form_builder)
    form_builder.radio_button :procedure_id, procedure.id,
      :data => {
        :'requires-tooth-number' => procedure.requires_tooth_number,
        :'requires-surface-code' => procedure.requires_surface_code
      }
  end

  def procedure_other_radio(form_builder)
    options = { :'data-generic-procedure' => true }

    if @selected_procedure && @selected_procedure == "other"
      options[:checked] = true
    end

    form_builder.radio_button :procedure_id, "other", options
  end

  def procedure_amalgam_composite_radio(form_builder)
    options = { :'data-amalgam-composite' => true }

    if @selected_procedure && @selected_procedure == "amalgam_composite"
      options[:checked] = true
    end

    form_builder.radio_button :procedure_id, "amalgam_composite", options
  end

  def tooth_visible(patient_procedure)
    return "display:none;" if patient_procedure.procedure.nil?
    "display:none;" unless patient_procedure.procedure.requires_tooth_number
  end

  def surface_visible(patient_procedure)
    return "display:none;" if patient_procedure.procedure.nil?
    "display:none;" unless patient_procedure.procedure.requires_surface_code
  end

  def other_visible
    return if @selected_procedure && @selected_procedure == "other"

    "display: none;"
  end

  def amcomp_visible
    return if @selected_procedure && @selected_procedure == "amalgam_composite"

    "display: none;"
  end

  def remove_procedure(patient_procedure)
    link_to image_tag("delete.png", :class => "side_image right"),
            patient_procedure_path(patient_procedure),
            :remote  => true,
            :method  => :delete,
            :confirm => "Are you sure you wish to remove this procedure?",
            :class   => "delete-procedure"
  end

  def link_to_previous(area, patient)
    if patient.survey and current_user.user_type != UserType::XRAY
      path = edit_treatment_area_patient_survey_path(area, patient)
      text = "Back"
      css  = "back"
    else
      path = treatment_area_patients_path(area)
      text = "Cancel"
      css  = "warning"
    end

    link_to text, path, :class => css
  end

  def continue_button(area, patient, options={})
    if area == TreatmentArea.radiology
      path = treatment_area_patients_path(area)
    else
      path = treatment_area_patient_prescriptions_path(area, patient)
    end

    text = options[:text] || "Continue"

    button_to text, path, :method => :get
  end

  def radiology_link(patient, remote=false)
    text = if dexis?
      "Export to Dexis"
    elsif cdr?
      "Export to CDR"
    elsif kodak?
      "Export to Kodak"
    else
      "Export"
    end

    options = { id: "export_to_xray", class: 'primary' }

    options[:data] = {remote: true} if remote

    link_to text,
            radiology_treatment_area_patient_path(TreatmentArea.radiology, patient),
            options

  end

  def checkout_path(area, patient)
    if area == TreatmentArea.radiology
      radiology_treatment_area_patient_path(area, patient)
    elsif patient.checked_out?
      treatment_area_patient_procedures_path(area, patient)
    else
      edit_treatment_area_patient_survey_path(area, patient)
    end
  end

  def button_to_next_checkout(area,patient)
    if area == TreatmentArea.radiology
      text = "Finish"
      path = treatment_area_patients_path(area)
    else
      text = "Next"
      path = treatment_area_patient_prescriptions_path(area, patient)
    end

    button_to text, path,
              :method => :get,
              :id     => "next-button"
  end

end
