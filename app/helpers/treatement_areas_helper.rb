module TreatementAreasHelper
  def has?(patient, procedure)
    patient.procedures.include?(procedure)
  end
  
  def procedure_radio(procedure, form_builder)
    form_builder.radio_button :procedure_id, 
                               procedure.id,
                              :onchange => "showCheckoutFields(#{procedure.requires_tooth_number},#{procedure.requires_surface_code}, false);"
  end
  
  def procedure_other_radio(form_builder)
    form_builder.radio_button :procedure_id, "other", :onchange => "showCheckoutFields(true,true, true);"
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
end
