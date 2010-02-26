module PatientsHelper
  def link_to_checkout(area, patient)
    if patient.survey
      path = treatement_area_pre_checkout_path(:id => area, :patient_id => patient.id)
    else
      path = treatement_area_checkout_path(:id => area, :patient_id => patient.id)
    end
    
    link_to "Checkout", path
  end
end