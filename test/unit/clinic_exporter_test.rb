require 'test_helper'

describe ClinicExporter do
  describe "#initialize" do
    it "takes single arguments" do
      clinic_exporter = ClinicExporter.new(:patients)

      clinic_exporter.data_types.must_equal [:patients]
    end

    it "takes no arguments which defaults to all" do
      clinic_exporter = ClinicExporter.new

      clinic_exporter.data_types.must_equal ClinicExporter::SUPPORTED_DATA_TYPES
    end

    it "takes multiple arguments" do
      clinic_exporter = ClinicExporter.new(:patients, :surveys)

      clinic_exporter.data_types.must_equal [:patients, :surveys]
    end
  end

  describe "#data" do
    it "returns all records for the requested data_types" do
      5.times { FactoryGirl.create(:patient) }

      clinic_exporter = ClinicExporter.new(:patients)

      clinic_exporter.data[:patients].length.must_equal 5
    end
  end
end
