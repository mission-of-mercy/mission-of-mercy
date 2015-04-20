class TreatmentAreas::Patients::PrescriptionsController < CheckoutController
  include CanHasPharmacy

  before_filter :authenticate_user!

  def index
    prescriptions
  end

  def update
    pharmacy_check_out

    @patient.check_out(@treatment_area)

    flash[:notice] = "Patient successfully checked out"
    stats.patient_checked_out

    redirect_to treatment_area_patients_path(@treatment_area)
  end
end
