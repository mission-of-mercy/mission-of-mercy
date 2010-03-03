module PatientsHelper
  def link_to_checkout(area, patient)
    name = TreatementArea.find(area).name
    
    link_to "#{name} Checkout", checkout_path(area,patient)
  end
  
  def checkout_path(area,patient)
    if patient.survey
      return treatement_area_pre_checkout_path(:id => area, :patient_id => patient.id)
    else
      return treatement_area_checkout_path(:id => area, :patient_id => patient.id)
    end
  end
end