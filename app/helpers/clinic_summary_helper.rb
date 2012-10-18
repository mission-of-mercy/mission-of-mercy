module ClinicSummaryHelper
  def procedures_per_hour(procedures)
    procedures.collect do |p|
      [p.hour, p.total]
    end
  end
end
