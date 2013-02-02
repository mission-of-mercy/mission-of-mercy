class PatientsTable
  include Enumerable

  def initialize(*fields)
    @fields = fields.empty? ? [:chart_number] : fields
  end

  def search(params)
    @patient_search = PatientSearch.new(params)

    @patients = patient_search.patients.
      paginate(per_page: 30, page: params[:page])

    @patient_search
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

  # Will Paginate methods

  def total_pages
    patients.total_pages
  end

  def current_page
    (patients.current_page || 1).to_i
  end

  def count
    patients.total_entries
  end

  private

  attr_reader :patients, :fields, :patient_search, :patient_controls

  def controls_for(patient)
    CaptureHelper.helpers.capture(patient, &patient_controls) if patient_controls
  end

end
