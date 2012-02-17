require 'test_helper'

class AdminTreatmentsTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :webkit
    sign_in_as 'Admin'
  end

  test "the navigation has a link for treatments" do
    assert admin_navigation.has_link?('Treatments'), 'No treatment link in nav'
  end

  test "when nav item is selected, the selected tab is treatments" do
    admin_navigation.click_link 'Treatments'
    assert admin_current_tab_is?('Treatments')
  end

  test "the treatments page lists all treatments" do
    t1 = Factory(:treatment, :name => 'Cleaning')
    t2 = Factory(:treatment, :name => 'Extraction')

    admin_navigation.click_link 'Treatments'

    assert page.has_content?('Cleaning')
    assert page.has_content?('Extraction')
  end

  test "creates a new treatment" do
    admin_navigation.click_link 'Treatments'
    refute page.has_content?('Some treatment name')

    click_link 'New'

    assert_equal 'New Treatment', page_header_text
    fill_in 'Name', :with => 'Some treatment name'
    click_button 'Save'

    assert_equal 'Treatments', page_header_text
    assert page.has_content?('Some treatment name')
  end

  test "updates existing treatments" do
    Factory(:treatment, :name => 'Cleaning')
    admin_navigation.click_link 'Treatments'
    assert page.has_content?('Cleaning')
    refute page.has_content?('Root canal')

    click_link 'Edit'

    assert_equal 'Edit Treatment', page_header_text
    fill_in 'Name', :with => 'Root canal'
    click_button 'Save'

    assert_equal 'Treatments', page_header_text
    assert page.has_content?('Treatment was successfully updated.')
    assert page.has_content?('Root canal')
    refute page.has_content?('Cleaning')
  end

  test "deletes existing treatments" do
    Factory(:treatment, :name => 'Cleaning')
    admin_navigation.click_link 'Treatments'
    assert page.has_content?('Cleaning')

    click_link 'Destroy'
    press_okay_in_dialog

    assert_equal 'Treatments', page_header_text
    refute page.has_content?('Cleaning')
  end
end
