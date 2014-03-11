require 'tmpdir'

class PrintChart
  @queue = :print_chart

  def self.perform(chart_id, printer=nil)
    job = new(chart_id, printer)
    job.print
  end

  def self.printers
    @printers ||= `lpstat -a`.split.map {|printer| printer[/\S*/] }
  end

  def initialize(chart_id, printer=nil)
    @patient = Patient.find(chart_id)
    @chart   = PatientChart.new(patient)
    @printer = printer
    @printed = false

    raise "Invalid Printer" unless valid_printer?
  end

  attr_reader :chart, :patient, :printer, :printed

  def print
    Dir.mktmpdir do |workdir|
      chart_path = "#{workdir}/chart_#{patient.id}.pdf"
      chart.render_file chart_path
      `lpr #{printer_option} #{chart_path}`
    end

    @printed = $?.success?

    patient.chart_printed = printed
    patient.save

    printed
  end

  private

  def valid_printer?
    printer.nil? || PrintChart.printers.include?(printer)
  end

  def printer_option
    return unless printer

    "-P #{printer}"
  end
end
