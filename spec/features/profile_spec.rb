require 'spec_helper'

feature 'Profile pages' do
  scenario 'Profile page lists the templates from a given person' do
    account = create :template_account

    visit "/#{account.username}"

    page.should have_content 'Test Template'
  end
end
