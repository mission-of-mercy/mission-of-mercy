module TreatementAreasHelper
  def has?(patient, procedure)
    patient.procedures.include?(procedure)
  end
  
  def procedure_radio(procedure, form_builder)
    form_builder.radio_button :procedure_id, 
                               procedure.id,
                              :onchange => "showCheckoutFields(#{procedure.requires_tooth_number},#{procedure.requires_surface_code}, false, false);"
  end
  
  def procedure_other_radio(form_builder)
    form_builder.radio_button :procedure_id, "other", :onchange => "showCheckoutFields(true,true, true, false);"
  end
  
  def procedure_amalgam_composite_radio(form_builder)
    form_builder.radio_button :procedure_id, "amalgam_composite", :onchange => "showCheckoutFields(true,true, false, true);"
  end
  
  def tooth_visible(patient_procedure)
    return "display:none;" if patient_procedure.procedure.nil?
    "display:none;" unless patient_procedure.procedure.requires_tooth_number
  end
  
  def surface_visible(patient_procedure)
    return "display:none;" if patient_procedure.procedure.nil?
    "display:none;" unless patient_procedure.procedure.requires_surface_code
  end
  
  def remove_procedure(patient_procedure)
    link_to_remote image_tag("delete.png", :class => "side_image right"),
                   :url => patient_procedure_path(patient_procedure),
                   :method => :delete,
                   :confirm => "Are you sure you wish to remove this procedure?",
                   :before => "$(this).hide(); $('loading_#{patient_procedure.id}').show();"
  end
  
  def link_to_finish(area, patient)
    if area.pharmacy
      session[:treatement_area_id] = area.id
      
      button_to "Next", pharmacy_check_out_path(patient),
                        { :method => :get, 
                          :onclick => "return procedure_not_added(#{flash[:procedure_added] == true});"}      
    else
      button_to "Finish", check_out_completed_path(area, patient),
                          {:onclick => "return procedure_not_added(#{flash[:procedure_added] == true});"}
    end
  end
  
  def continue_button(area,patient)
    path = pharmacy_check_out_path(patient) if area.pharmacy
    path ||= check_out_completed_path(area, patient)
    
    method = :get if area.pharmacy
    method ||= :post
    
    button_to "Continue", path, :method => method
  end
  
  def link_to_previous(area, patient)
    if patient.survey and current_user.user_type != UserType::XRAY
      path = treatement_area_pre_checkout_path(:treatement_area_id => area, :patient_id => patient.id)
      text = "Back"
      css  = "back"
    else
      path = patients_path(:treatement_area_id => area.id)
      text = "Cancel"
      css  = "warning"
    end
    
    link_to text, path, :class => css
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

end
