require_relative '../test_helper'

DatabaseCleaner.strategy = :transaction

describe 'PrintChart' do
  let(:patient) { FactoryGirl.create(:patient, chart_printed: false) }

  it 'updates the patient record after printing' do
    PrintChart.stub_any_instance(:send_to_printer, true) do
      print_chart = PrintChart.new(patient.id)
      print_chart.print
    end

    patient.reload.chart_printed.must_equal true
  end

  it 'raises an exception if the specified printer is unknown' do
    valid_printers = %w[printer_1 printer_2]

    PrintChart.stub(:printers, [valid_printers]) do
      proc { PrintChart.new(patient.id, 'invalid') }.must_raise ArgumentError
    end
  end

  it 'prints to the specified printer' do
    printer = 'printer_1'

    PrintChart.stub(:printers, [printer]) do
      print_chart = PrintChart.new(patient.id, printer)

      print_chart.printer.must_equal printer
    end
  end
end
