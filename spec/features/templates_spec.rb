require 'spec_helper'

feature 'Templates' do
  background do
    sign_in_with(create(:test_account))
  end

  scenario 'Adding a new template', :git => true, :js => true do
    click_link 'Dashboard'
    click_link 'Add Template'

    click_link 'Enter manually'
    fill_in 'Uri',   :with => File.expand_path('vendor/repos/igata_test', Rails.root)
    click_link 'Set Title and Price'
    fill_in 'Name',  :with => 'Test Template'
    fill_in 'Price', :with => '100'
    click_link 'Upload screenshots'
    attach_file 'template_screenshots_attributes_1', File.expand_path('spec/support/socko.png', Rails.root)
    click_button 'Create'
    page.should have_content 'Test Template'

    click_link 'Test Template'
    page.should have_selector '.thumb img'
  end

  scenario 'Adding a new template with invalid info' do
    click_link 'Dashboard'
    click_link 'Add Template'
    current_path.should eq new_template_path
  end

  scenario 'Updating a template' do
    template = create(:test_template, :account => current_account)
    click_link 'Dashboard'

    click_link 'Test Template'
    fill_in 'Name', :with => 'Changed Template'
    click_button 'Update'
    template.reload
    current_path.should eq edit_template_path(template)
    page.should have_content 'Changed Template'
  end

  scenario 'Deleting a template', :js do
    template = create(:test_template, :account => current_account)
    click_link 'Dashboard'
    click_link 'Test Template'

    click_link 'Delete'
    current_path.should eq edit_template_path(template.slug)
    click_link 'Delete'
    current_path.should eq my_templates_path
    sleep_for(9, 'Waiting for Sucessful Deletion of Template header to disapper')
    page.should_not have_content 'Test Template'
  end
end
