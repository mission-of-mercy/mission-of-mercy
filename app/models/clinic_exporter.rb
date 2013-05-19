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
    end
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

  # Public the data for each requested +data_type+
  #
  # Returns a Hash of the data
  def data
    data_types.each_with_object({}) do |data_type, data|
      data[data_type] = class_for(data_type).all.map(&:attributes)
    end
  end

  private

  def class_for(data_type)
    data_type.to_s.classify.constantize
  end
end
