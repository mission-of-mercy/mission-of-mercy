class ProcedureDecorator < ApplicationDecorator
  def radio_button(form_builder)
    form_builder.label(:procedure_id, :value => procedure.id) do
      form_builder.radio_button(:procedure_id, procedure.id,
        :required => true,
        :data => {
          :'requires-tooth-number' => procedure.requires_tooth_number,
          :'requires-surface-code' => procedure.requires_surface_code
        }) +
        " " + procedure.full_description.html_safe
    end
  end
end
