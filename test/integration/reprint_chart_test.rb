require_relative '../test_helper'

class ReprintChartTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit
    @patient = FactoryGirl.create(:patient)
  end

  test "charts can be reprinted" do
    sign_in_as "Check in"

    click_link "Reprint chart"

    fill_in "Chart number", with: @patient.id

    click_button "Search"

    within("#contents") { click_link "Reprint" }

    within_window('Mission of Mercy - Print') do
      # Spot check chart details
      assert_content @patient.id
      assert_content @patient.last_name
    end

  end

  test "charts which were never printed are displayed by default" do
    chart_not_printed = FactoryGirl.create(:patient, chart_printed: false)

    sign_in_as "Check in"

    click_link "Reprint chart"

    within('#contents table') do
      assert_no_content @patient.last_name
      assert_no_content "Reprint"

      click_link "Print"
    end

    within_window('Mission of Mercy - Print') do
      # Spot check chart details
      assert_content chart_not_printed.id
      assert_content chart_not_printed.last_name
    end
  end
end
