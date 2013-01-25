class PatientSearch
  include Enumerable

  def initialize(*fields)
    @fields        = fields || [:chart_number]
    @search_params = {}
  end

  def search(params)
    @search_params = params

    find_patients

    self
  end

  def each
    patients.each {|patient| yield patient, controls_for(patient) }
  end

  def controls_for(patient)
    "Hi #{patient.full_name}!"
  end

  def show?(field)
    fields.include? field
  end

  def [](param)
    search_params[param]
  end

  # Will Paginate methods

  def total_pages
    patients.total_pages
  end

  private

  attr_reader :patients, :fields, :search_params

  def find_patients
    if search_params[:commit] == "Clear"
      @search_params = {}
    end

    chart_number = search_params[:chart_number]
    name         = search_params[:name]

    patients = if chart_number.blank? && !name.blank?
      Patient.where('first_name ILIKE :name or last_name ILIKE :name',
        name: "%#{name}%")
    elsif !chart_number.blank? && chart_number.to_i != 0
      Patient.where(id: chart_number)
    else
      @search_params = {}
      Patient.where(id: -1)
    end

    @patients = patients.order('id').
      paginate(per_page: 30, page: search_params[:page])
  end
end