class PatientsTable
  include Enumerable

  def initialize(*fields)
    @fields = fields.empty? ? [:chart_number] : fields
  end

  def search(params)
    @patient_search = PatientSearch.new(params)

    @patients = patient_search.execute.
      paginate(per_page: 30, page: params[:page])

    self
  end

  def each
    patients.each {|patient| yield patient, controls_for(patient) }
  end

  def controls(&block)
    @patient_controls = block
  end

  def show?(field)
    fields.include?(field)
  end

  def [](param)
    patient_search.send(param)
  end

  # Will Paginate methods

  def total_pages
    patients.total_pages
  end

  def current_page
    (patients.current_page || 1).to_i
  end

  private

  attr_reader :patients, :fields, :patient_search, :patient_controls

  def controls_for(patient)
    h.capture(patient, &patient_controls) if patient_controls
  end

  # TODO Desc ...
  #
  def h
    @h ||= begin
      h = ActionController::Base.helpers.extend(Haml::Helpers)
      h.init_haml_helpers
      h
    end
  end

end
