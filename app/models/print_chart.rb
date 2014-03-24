require 'tmpdir'

class PrintChart
  @queue = :print_chart

  def self.perform(chart_id, printer=nil)
    job = new(chart_id, printer)
    job.print
  end

  # List of available printers
  #
  def self.printers
    JSON.parse($redis.get('printers'))
  rescue Redis::CannotConnectError, TypeError
    []
  end

  # Update list of available printers on the current system
  #
  def self.update_printers!
    printers = `lpstat -a`.split("\n").map {|printer| printer[/\S*/] }
    $redis.set 'printers', printers.to_json
  end

  def initialize(chart_id, printer=nil)
    @patient = Patient.find(chart_id)
    @chart   = PatientChart.new(patient)
    @printer = printer
    @printed = false

    raise ArgumentError.new("Invalid Printer") unless valid_printer?
  end

  attr_reader :chart, :patient, :printer, :printed

  def print
    Dir.mktmpdir do |workdir|
      chart_path = "#{workdir}/chart_#{patient.id}.pdf"
      chart.render_file chart_path
      @printed = send_to_printer(chart_path)
    end

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

  def send_to_printer(chart_path)
    `lpr #{printer_option} #{chart_path}`
    $?.success?
  end
end
