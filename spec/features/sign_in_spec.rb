require 'spec_helper'

feature 'Sign in' do
  background do
    visit sign_in_path
  end

  scenario 'with valid info' do
    account = create(:test_account)
    sign_in_with(account)
    current_path.should eq root_path
    page.should have_content 'Dashboard'
  end

  scenario 'with invalid info' do
    click_button 'Sign in'

    current_path.should eq sign_in_path
    page.should have_content 'Sign in'
  end
end
