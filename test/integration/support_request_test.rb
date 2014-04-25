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
      [request.description, request.created_at]
  end

  it "tracks the current treatment area if present" do
    treatment_area = FactoryGirl.create(:treatment_area)

    sign_in_as "Check out"

    click_link treatment_area.name

    click_link "help_link"

    page.must_have_content "Help is on the way"

    request = SupportRequest.first

    request.treatment_area.must_equal treatment_area
  end

  it "can be canceled" do
    sign_in_as "Check in"

    click_link "help_link"

    page.must_have_content "Help is on the way"

    click_link "Cancel your request"

    page.wont_have_css "body.support-requested"

    SupportRequest.first.resolved.must_equal true
  end
end
