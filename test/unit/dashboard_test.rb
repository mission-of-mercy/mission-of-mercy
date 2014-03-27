require_relative "../test_helper"

describe "Dashboard" do
  let(:dashboard) { Dashboard.new }

  it "patients_summary smoke test" do
    summary = dashboard.patients_summary

    summary.keys.must_include :in_clinic
  end
end
