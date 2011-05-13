module TreatmentAreasHelper
  def has?(patient, procedure)
    patient.procedures.include?(procedure)
  end
  
  def procedure_radio(procedure, form_builder)
    form_builder.radio_button :procedure_id, 
                               procedure.id,
                              :onchange => "showCheckoutFields(#{procedure.requires_tooth_number},#{procedure.requires_surface_code}, false, false);"
  end
  
  def procedure_other_radio(form_builder)
    options = {:onchange => "showCheckoutFields(true,true, true, false);"}
    
    if @selected_procedure && @selected_procedure == "other"
      options[:checked] = true
    end
    
    form_builder.radio_button :procedure_id, "other", options
  end
  
  def procedure_amalgam_composite_radio(form_builder)
    options = {:onchange => "showCheckoutFields(true,true, false, true);"}
    
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
    link_to_remote image_tag("delete.png", :class => "side_image right"),
                   :url => patient_procedure_path(patient_procedure),
                   :method => :delete,
                   :confirm => "Are you sure you wish to remove this procedure?",
                   :before => "$(this).hide(); $('loading_#{patient_procedure.id}').show();"
  end
  
  def link_to_previous(area, patient)
    if patient.survey and current_user.user_type != UserType::XRAY
      path = treatment_area_patient_survey_path(area, patient)
      text = "Back"
      css  = "back"
    else
      path = treatment_area_patients_path(area)
      if current_user.user_type == UserType::XRAY
        path = patients_path
      end
      text = "Cancel"
      css  = "warning"
    end
    
    link_to text, path, :class => css
  end
  
  def continue_button(area, patient, options={})
    if area == TreatmentArea.radiology
      path = patients_path
    else
      path = treatment_area_patient_prescriptions_path(area, patient)
    end
    
    text = options[:text] || "Continue"
    
    button_to text, path, :method => :get
  end
  
  def link_to_export_to_dexis(patient)
    link_to_remote "Export to Dexis", 
                   :url  => export_to_dexis_file_path(:patient_id => patient.id),
                   :before => "$('exporting').show()"
  end
  
  def radio_treatment_area(form, area)
    form.radio_button :assigned_treatment_area_id, 
                      area.id, 
                      :onmouseover => "graph_highlight('#{area.name.to_s.downcase.gsub(' ', '_')}');",
                      :onmouseout => "graph_reset();"
  end
  
  def radiology_check_box(form)
    form.check_box :radiology, 
                   :onmouseover => "graph_highlight('radiology');",
                   :onmouseout => "graph_reset();"
  end
  
  def radiology_label(form)
    form.label :radiology, "Radiology",
    :onmouseover => "graph_highlight('radiology');",
    :onmouseout => "graph_reset();"
  end

  def graph_label(form,area)
    form.label :assigned_treatment_area_id, area.name, :value => area.id,
    :onmouseover => "graph_highlight('#{area.name.to_s.downcase.gsub(' ', '_')}');",
    :onmouseout => "graph_reset();"
  end
  
  def over_capacity(areas)
    js = ""
    
    areas.each do |a|
      if a.patients.length >= (a.capacity || 0)
        id = a.name.to_s.downcase.gsub(' ', '_')
        js += "$($$('dd.#{id}').first()).addClassName('over');"
      end
    end
    
    js
  end
  
  def checkout_path(area, patient)
    if patient.survey
      treatment_area_patient_survey_path(area, patient)
    else
      treatment_area_patient_procedures_path(area, patient)
    end
  end
  
  def button_to_next_checkout(area,patient)
    if area == TreatmentArea.radiology
      text = "Finish"
      path = patients_path
    else
      text = "Next"
      path = treatment_area_patient_prescriptions_path(area, patient)
    end
    
    button_to text, path, 
              :method => :get, 
              :onclick => "return procedure_not_added(#{@procedure_added});"
  end

end
