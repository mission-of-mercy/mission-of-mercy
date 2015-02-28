require_relative '../test_helper'

feature "Reprinting a patient's chart" do
  before :each do
    Capybara.current_driver = Capybara.javascript_driver
    Resque.reset!
    @patient = FactoryGirl.create(:patient)

    sign_in_as "Check in"
  end

  test "charts can be reprinted" do
    PrintChart.stub('printers', ['printer']) do
      click_link "Reprint chart"

      fill_in "Chart number", with: @patient.id

      click_button "Search"

      select_printer

      within("#contents") { click_link "Reprint" }

      assert_content "Printing"
      assert_queued PrintChart, [@patient.id, "printer"]
    end
  end

  test "charts which were never printed are displayed by default" do
    PrintChart.stub('printers', ['printer']) do
      chart_not_printed = FactoryGirl.create(:patient, chart_printed: false)

      click_link "Reprint chart"

      select_printer

      within('#contents table') do
        assert_no_content @patient.last_name
        assert_no_content "Reprint"

        click_link "Print"
      end

      assert_content "Printing"
      assert_queued PrintChart, [chart_not_printed.id, "printer"]
    end
  end
end
