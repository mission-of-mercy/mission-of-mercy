class Registration
  def initialize(params)
    @params           = params
    @patient          = Patient.new(params[:patient])
    @last_patient     = Patient.find_by_id(params[:last_patient_id])
    @previous_patient = Patient.find_by_id(patient.previous_chart_number)

    patient.build_previous_mom_clinics

    if previous_patient
      load_previous_patient_into_current_patient
    else
      patient.survey ||= Survey.new
    end
  end

  def create!
    return false if errors?
    add_procedures
    patient.save
  end

  def form_data
    {
      last_patient_id: last_patient.try(:id),
      last_patient_contact: last_patient.try(:contact_information),
      require_waiver_confirmation: show_waver?,
      date_input: date_input
    }
  end

  def decorated_patient
    patient.decorate
  end

  def show_waver?
    !(errors? || previous_patient)
  end

  def date_input
    @date_input ||= params[:date_input] || 'text'
  end

  def next_button
    if previous_patient
      h.submit_tag("Check In")
    else
      h.content_tag('button', 'Next', id: 'bottom_demographics_next' )
    end
  end

  private

  # FIXME previous_patient and last_patient are confusing
  #
  attr_reader :params, :patient, :previous_patient, :last_patient

  def errors?
    patient.errors.size > 0
  end

  def add_procedures
    procedures = Procedure.where(auto_add: true)

    procedures.each do |procedure|
      patient.patient_procedures.build(procedure_id: procedure.id)
    end
  end

  def load_previous_patient_into_current_patient
    %w[ first_name last_name date_of_birth sex race phone street zip city
        state last_dental_visit travel_time].each do |attr|
      patient[attr] ||= previous_patient[attr]
    end
  end

  def h
    ActionController::Base.helpers
  end
end