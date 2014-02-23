require_relative '../test_helper'

feature "Reprinting a patient's chart" do
  before :each do
    Capybara.current_driver = Capybara.javascript_driver
    @patient = FactoryGirl.create(:patient)

    sign_in_as "Check in"
  end

  test "charts can be reprinted" do
    click_link "Reprint chart"

    fill_in "Chart number", with: @patient.id

    click_button "Search"

    within("#contents") { click_link "Reprint" }

    # Make sure the chart window opened
    #
    page.driver.browser.window_handles.count.must_equal 2
  end

  test "charts which were never printed are displayed by default" do
    chart_not_printed = FactoryGirl.create(:patient, chart_printed: false)

    click_link "Reprint chart"

    within('#contents table') do
      assert_no_content @patient.last_name
      assert_no_content "Reprint"

      click_link "Print"
    end

    # Make sure the chart window opened
    #
    page.driver.browser.window_handles.count.must_equal 2
  end
end
