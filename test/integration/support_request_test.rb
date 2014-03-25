require_relative  '../test_helper'

feature "Need Help" do
  before do
    Capybara.current_driver = Capybara.javascript_driver
  end

  it "creates a support notification" do
    sign_in_as "Check in"

    click_link "help_link"

    page.must_have_content "Help is on the way"

    request = SupportRequest.first

    assert_queued SupportNotification,
      [request.station_description, request.created_at]
  end

  it "can be canceled" do
    sign_in_as "Check in"

    click_link "help_link"

    page.must_have_content "Help is on the way"

    within("#activebar-container") do
      find("div.close").click
    end

    page.wont_have_content "Help is on the way"

    SupportRequest.first.resolved.must_equal true
  end
end
