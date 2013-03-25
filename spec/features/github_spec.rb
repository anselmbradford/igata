require 'spec_helper'

feature 'Linking github account and adding templates from github', :js do
  context 'No Github account linked' do
    scenario 'New template page has a link to auth with github' do
      pending 'This test no longer makes sense, as the Github button does double duty'
      sign_in_with(create(:test_account))
      click_link 'Dashboard'
      click_link 'Add Template'

      page.should have_link 'Github'
    end
  end
end
