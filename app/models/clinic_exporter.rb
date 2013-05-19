class ClinicExporter
  SUPPORTED_DATA_TYPES = %w[patients procedures prescriptions pre_meds surveys]
  attr_reader :data_types

  # Public creates an exporter object which will dump the requested data
  #
  # - data_types: Array of data types to be exported
  #
  # Returns a new ClinicExporter
  def initialize(*data_types)
    @data_types = if data_types.empty?
      SUPPORTED_DATA_TYPES
    else
      data_types
    end.map(&:to_s)

    format_file = Rails.root.join('config/clinic_exporter_formats.yml')
    @formats    = YAML.load_file(format_file)
  end

  def to_xlsx
    raise NotImplementedError
  end

  def to_csv
    raise NotImplementedError
  end

  def to_json
    raise NotImplementedError
  end

  # Public formatted records matching the requested +data_type+
  #
  # Returns a Hash of the data
  def data
    @data ||= begin
      data_types.each_with_object({}) do |data_type, data|
        data[data_type] = class_for(data_type).all.map {|r| format(r, data_type) }
      end
    end
  end

  private

  attr_reader :formats

  def class_for(data_type)
    data_type.classify.constantize
  end

  def format(record, data_type)
    formatted_record = formats[data_type].map {|k,v| [v, record.send(k)] }
    Hash[*formatted_record.flatten]
  end
end
