class TreatmentAreas::Patients::SurveysController < CheckoutController
  before_filter :authenticate_user!

  def edit
    @survey = @patient.survey

    @patient.patient_pre_meds.each do |p|
      p.prescribed = true
    end

    PreMed.all.each do |med|
      unless @patient.pre_meds.exists? med
        @patient.patient_pre_meds.build(:pre_med_id => med.id)
      end
    end
  end

  def update
    if @patient.update_attributes(patient_params)
      redirect_to treatment_area_patient_procedures_path(@treatment_area, @patient)
    else
      render :action => "edit"
    end
  end

  private

  def patient_params
    params.require(:patient).permit(
      survey_attributes: %w[tobacco_use told_needed_more_dental_treatment
        rating_of_services id],
      patient_pre_meds_attributes: %w[pre_med_id prescribed id]
    )
  end
end
