module TreatementAreasHelper
  def has?(patient, procedure)
    patient.procedures.include?(procedure)
  end
  
  def add_procedure_link(link_text, procedure, form_builder)
    pp = form_builder.object.patient_procedures.build(:procedure_id => procedure.id)
    
    link_to_function( link_text , :class => "add" ) do |page|
      form_builder.fields_for :patient_procedures, pp, :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'procedure', :locals => { :p => f })
        page << "var newID = new Date().getTime();"
        page << "$('#{procedure.id}').insert({ bottom: '#{escape_javascript(html)}'.replace(/NEW_RECORD/g, newID) });"
      end
    end
  end
  
  def remove_procedure_link(link_text, form_builder)
    if form_builder.object.new_record?
      # If the task is a new record, we can just remove the div from the dom
      link_to_function(link_text, "$(this).up('.procedure').remove()",
        :title => "Remove Procedure")
    else
      # However if it's a "real" record it has to be deleted from the database,
      # for this reason the new fields_for, accept_nested_attributes helpers give us _delete,
      # a virtual attribute that tells rails to delete the child record.
      form_builder.hidden_field(:_delete) +
      link_to_function(link_text, 
        "$(this).up('.procedure').hide(); $(this).previous().value = '1'", 
        :title => "Remove Procedure")
    end
  end
end
