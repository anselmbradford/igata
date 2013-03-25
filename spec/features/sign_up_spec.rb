require 'spec_helper'

feature 'Signing up' do
  background do
    visit sign_up_path
  end

  scenario 'with valid info' do
    valid_account = build(:test_account)
    fill_in 'Name',                  :with => valid_account.name
    fill_in 'Email',                 :with => valid_account.email
    fill_in 'Username',              :with => valid_account.username
    fill_in 'password',              :with => valid_account.password
    fill_in 'password_confirmation', :with => valid_account.password_confirmation
    click_button 'Sign up'

    current_path.should eq dashboard_path
    page.should have_content 'Dashboard'
  end

  scenario 'with invalid info' do
    click_button 'Sign up'

    current_path.should eq sign_up_path
    page.should have_content 'Sign up'
  end
end
