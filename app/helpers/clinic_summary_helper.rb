module ClinicSummaryHelper
  def per_hour(records)
    return [] if records.empty?

    start_time = records.first.hour
    end_time   = records.last.hour

    total_hours = ((end_time - start_time)/3600 + 1).to_i

    total_hours.times.map do |index|
      hour         = start_time + index.hours
      record_count = records.find {|r| r.hour == hour }.try(:total) || 0

      [hour.strftime('%H:%M'), record_count]
    end
  end
end
