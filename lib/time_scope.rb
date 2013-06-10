module TimeScope
  def span_time(day, span)
    # Parse time with current date to make sure any timezone offsets are correct
    Time.zone.parse(
      [day.strftime('%Y-%m-%d'),span].join(' ')
    ).utc.strftime("%H:%M:00")
  end

  def for_time(table, day, span)
    relation = self
    unless day == 'All'
      relation = relation.where("#{table}.created_at::Date = ?", day)
      unless span == 'All'
        relation = relation.
          where("#{table}.created_at::Time <= ?", span_time(day, span))
      end
    end
    relation
  end
end
