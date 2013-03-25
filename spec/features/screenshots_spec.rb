require 'spec_helper'

feature 'Screenshots' do
  background do
    account = create(:test_account)
    sign_in_with(account)
    create(:test_template, :account => account)
  end

  scenario 'Adding a screenshot to an existing template', :js => true do
    visit my_templates_path
    page.should_not have_selector '.thumb img'

    click_link 'Test Template'
    click_link 'Add a screenshot'

    attach_file 'Image', File.expand_path('spec/support/socko.png', Rails.root)
    click_button 'Create Screenshot'

    page.should have_selector '.thumb img'
  end

  scenario 'Removing a screenshot from a template' do
    visit my_templates_path
    page.should_not have_selector '.thumb img'

    click_link 'Test Template'
    click_link 'Add a screenshot'

    attach_file 'Image', File.expand_path('spec/support/socko.png', Rails.root)
    click_button 'Create Screenshot'

    within '.screenshots' do
      click_link 'Delete'
    end

    page.should_not have_selector '.thumb img'
  end
end
