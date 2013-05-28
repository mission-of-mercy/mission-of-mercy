class ClinicExporter
  SUPPORTED_DATA_TYPES = %w[patients procedures prescriptions pre_meds surveys]
  attr_reader :data_types

  # Public creates an exporter object which will dump the requested data
  #
  # - data_types: Array of data types to be exported
  #
  # Returns a new ClinicExporter
  def initialize(*data_types)
    @data_types = (data_types.presence || SUPPORTED_DATA_TYPES).map(&:to_s)
    format_file = Rails.root.join('config/clinic_exporter_formats.yml')
    @formats    = YAML.load_file(format_file)
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
    if %[procedures prescriptions pre_meds].include? data_type
      data_type = "patient_#{data_type}"
    end
    data_type.classify.constantize
  end

  def format(record, data_type)
    formatted_record = formats[data_type].map {|k,v| column(record, k, v) }
    Hash[*formatted_record.flatten]
  end

  # Private retrieve the requested column data
  #
  # record - Object with methods to be called
  # key    - String of the method name to call
  # value  - String of the column name OR Hash of methods to call
  #
  # Returns an array of column title and its corresponding data
  #
  def column(record, key, value)
    if Hash === value
      value.map {|k, v| column(record.try(key), k,v) }
    else
      [value, record.try(key)]
    end
  end
end
