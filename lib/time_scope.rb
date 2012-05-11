module TimeScope
  def span_time(day, span)
    # Parse time with current date to make sure any timezone offsets are correct
    Time.zone.parse(
      [day.strftime('%Y-%m-%d'),span].join(' ')
    ).utc.strftime("%H:%M:00")
  end

  def scope_by_time(table, day, span)
    query = self
    unless day == 'All'
      query = query.where("#{table}.created_at::Date = ?", day)
      unless span == 'All'
        query = query.where("#{table}.created_at::Time <= ?", span_time(day, span))
      end
    end
    query
  end
end