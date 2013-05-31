require 'test_helper'

describe PatientPrescription do
  let(:patient) { FactoryGirl.create(:patient) }
  let(:prescription) { FactoryGirl.create(:prescription) }

  it "deletes itself if not prescribed" do
    patient_prescription = FactoryGirl.create(:patient_prescription,
      patient: patient, prescription: prescription)

    patient_prescription.prescribed = false

    patient_prescription.save

    patient_prescription.destroyed?.must_equal true
  end

  it "deletes itself if not prescribed through a patient" do
    patient_prescription = FactoryGirl.create(:patient_prescription,
      patient: patient, prescription: prescription)

    patient.attributes = {patient_prescriptions_attributes: {
      patient_prescription.id => patient_prescription.attributes.
        merge(prescribed: false)
    }}

    patient.save

    PatientPrescription.find_by_id(patient_prescription.id).must_equal nil
  end

end
