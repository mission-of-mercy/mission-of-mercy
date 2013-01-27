class PatientSearch

  def initialize(params={})
    @params = params
  end

  def execute
    if params[:commit] == "Clear"
      @params = {}
    end

    chart_number = params[:chart_number]
    name         = params[:name]

    patients = if chart_number.present?
      Patient.where(id: chart_number)
    elsif name.present?
      Patient.where('first_name ILIKE :name or last_name ILIKE :name',
        name: "%#{name}%")
    else
      @params = {}
      Patient.none
    end

    patients.order('id')
  end

  def []=(key, value)
    @params[key] = value
  end

  def [](key)
    params[key]
  end

  private
  attr_reader :params

end