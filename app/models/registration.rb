class Registration
  def initialize(options = {})
    @params  = options[:params]
    @patient = if options[:patient]
      options[:patient]
    else
      Patient.new(patient_params)
    end
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

  def save!
    return false if errors?
    patient.update_attributes(patient_params)
  end

  def form_data
    {
      last_patient_id: last_patient.try(:id),
      last_patient_contact: last_patient.try(:contact_information),
      require_waiver_confirmation: show_waver?,
      date_input: date_input,
      last_patient_chart_printed: last_patient.try(:chart_printed)
    }
  end

  def decorated_patient
    patient.decorate
  end

  def show_waver?
    !(errors? || previous_patient || patient.persisted?)
  end

  def date_input
    @date_input ||= params[:date_input] || 'text'
  end

  def next_button
    text = if previous_patient
      "Check In"
    else
      "Next"
    end

    h.submit_tag(text, class: 'btn btn-primary')
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
        state last_dental_visit travel_time travel_method].each do |attr|
      patient[attr] ||= previous_patient[attr]
    end
  end

  def h
    ActionController::Base.helpers
  end

  def patient_params
    return {} unless params[:patient]
    params.require(:patient).permit(*%w[previous_chart_number first_name
      last_name date_of_birth sex race race_other phone street zip city state
      chief_complaint last_dental_visit pain time_in_pain travel_time_hours
      travel_time_minutes attended_previous_mom_event pain_length_in_days
      travel_time pregnant has_obgyn due_date follow_up obgyn_name travel_method] +
      [:previous_mom_clinics_attributes => %w[location clinic_year attended id]]
    )
  end
end
