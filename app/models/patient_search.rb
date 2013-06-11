class PatientSearch
  include Virtus
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attribute :chart_number,      Integer
  attribute :treatment_area_id, Integer
  attribute :procedure_id,      Integer
  attribute :age,               Integer
  attribute :name,              String
  attribute :chart_printed,     Boolean

  def initialize(params)
    super params[:patient_search]
    reset_attributes if params[:commit] == 'Clear'
  end

  def patients
    if blank_search?
      return Patient.none
    elsif chart_number.present?
      return Patient.where(id: chart_number)
    end

    # TODO Turn these into scopes?

    patients = Patient.scoped
    if name.present?
      patients = patients.where(
        'first_name ILIKE :name or last_name ILIKE :name', name: "%#{name}%"
      )
    end

    if treatment_area_id.present?
      patients = patients.joins(:treatment_areas).where(
        'treatment_areas.id = ?', treatment_area_id
      )
    end

    if age.present?
      patients = patients.where(
        "date_part('year', age(date_of_birth)) = ?", age
      )
    end

    if procedure_id.present?
      patients = patients.joins(:procedures).where(
        'procedures.id = ?', procedure_id
      )
    end

    unless chart_printed.nil?
      patients = patients.where(chart_printed: chart_printed)
    end

    patients.order('id')
  end

  def reset_attributes
    attributes.each do |key, value|
      self[key] = nil
    end
  end

  def blank_search?
    attributes.values.all?(&:blank?) && chart_printed.nil?
  end

  def persisted?; false; end
end
