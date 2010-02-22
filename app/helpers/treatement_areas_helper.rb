module TreatementAreasHelper
  def has?(patient, procedure)
    patient.procedures.include?(procedure)
  end
end
