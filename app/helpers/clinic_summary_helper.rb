module ClinicSummaryHelper
  def per_hour(procedures)
    return [] if procedures.empty?

    start_time = procedures.first.hour
    end_time = procedures.last.hour

    total_hours = ((end_time - start_time)/3600 + 1).to_i

    data = {}
    total_hours.times do |index|
      data[start_time + index.hours] = 0
    end

    procedures.collect do |p|
      data[p.hour] = p.total
    end

    data.collect do |k, v|
      [k.strftime('%H:%M'), v]
    end
  end
end
