class Registration

  def initialize(params)
    @patient = Patient.new(params[:patient])
    if previous_patient?
      load_previous_patient
    else
      @patient.survey ||= Survey.new
    end
  end

  def previous_patient?
    !@patient.previous_chart_number.blank?
  end

  def patient
    @patient.decorate
  end

  def next_button
    if previous_patient?
      h.submit_tag("Check In")
    else
      h.content_tag('button', 'Next', id: 'bottom_demographics_next' )
    end
  end

  private

  def load_previous_patient
    @previous_patient = Patient.find(@patient.previous_chart_number)

    %w[ first_name last_name date_of_birth sex race phone street zip city
        state last_dental_visit travel_time].each do |attr|
      @patient[attr] ||= @previous_patient[attr]
    end
  end

  def h
    ActionController::Base.helpers
  end
end