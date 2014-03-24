module TreatmentAreasHelper
  def has?(patient, procedure)
    patient.procedures.include?(procedure)
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
