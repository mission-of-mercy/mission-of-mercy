class TreatmentAreas::Patients::ProceduresController < CheckoutController
  before_filter :authenticate_user!
  before_filter :tooth_numbers

  def index
    @patient_procedure = @patient.patient_procedures.build

    @patient.patient_prescriptions.each do |p|
      p.prescribed = true
    end

    Prescription.all.each do |pres|
      unless @patient.prescriptions.exists? pres
        @patient.patient_prescriptions.build(:prescription_id => pres.id)
      end
    end

    @procedure_added = params.has_key?(:procedure_added)
  end

  # FIXME Cowboy coded @ GMOM 2013
  #
  def create
    if tooth_numbers = params[:patient_procedure].delete(:tooth_numbers)
      tooth_numbers.each do |tooth|
        PatientProcedure.create(patient_procedure_params.
          merge(tooth_number: tooth))

        stats.procedure_added
      end

      @patient_procedure = @patient.patient_procedures.build

      redirect_to treatment_area_patient_procedures_path(:procedure_added => true)
    else
      @patient_procedure = PatientProcedure.new(patient_procedure_params)

      if @patient_procedure.save

        stats.procedure_added

        @patient_procedure = @patient.patient_procedures.build

        redirect_to treatment_area_patient_procedures_path(:procedure_added => true)
      else
        render :action => :index
      end
    end
  end

  private

  def tooth_numbers
    @tooth_numbers = [%w[LL LR UL UR], ('A'..'T').to_a, (1..32).to_a]
  end

  def patient_procedure_params
    params.require(:patient_procedure).permit!
  end
end
