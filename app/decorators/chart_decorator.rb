class ChartDecorator
  def initialize(data)
    @data = data
  end

  def top_by_value(maximum=10)
    @data.order('subtotal_value desc').collect do |entry|
      [entry.description, entry.subtotal_value]
    end[0..(maximum - 1)]
  end

  def top_by_quantity(maximum=10)
    @data.order('subtotal_count desc, subtotal_value desc').collect do |entry|
      [entry.description, entry.subtotal_count]
    end[0..(maximum - 1)]
  end
end
