require 'test_helper'

describe ClinicExporter do
  describe "#initialize" do
    it "takes single arguments" do
      clinic_exporter = ClinicExporter.new(:patients)

      clinic_exporter.data_types.must_equal ['patients']
    end

    it "takes no arguments which defaults to all" do
      clinic_exporter = ClinicExporter.new

      clinic_exporter.data_types.must_equal ClinicExporter::SUPPORTED_DATA_TYPES
    end

    it "takes multiple arguments" do
      clinic_exporter = ClinicExporter.new(:patients, :surveys)

      clinic_exporter.data_types.must_equal %w[patients surveys]
    end
  end

  describe "#data" do
    let(:clinic_exporter) { ClinicExporter.new(:patients) }

    before do
      5.times { FactoryGirl.create(:patient) }
    end

    it "returns all records for the requested data_types" do
      clinic_exporter.data['patients'].length.must_equal 5
    end

    it "uses the format file as keys" do
      format_file = Rails.root.join('config/clinic_exporter_formats.yml')
      formats     = YAML.load_file(format_file)

      patient = clinic_exporter.data['patients'].first

      patient.keys.must_equal formats['patients'].values
    end

    it "can read associations" do
      procedure = FactoryGirl.create(:procedure)
      Patient.find_each {|p| p.procedures << procedure }
      clinic_exporter = ClinicExporter.new(:procedures)

      procedure_row = clinic_exporter.data['procedures'].last

      procedure_row["Procedure Description"].must_equal procedure.description
    end
  end
end
