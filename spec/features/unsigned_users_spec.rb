require 'spec_helper'

feature 'Unsigned Users:' do
  let(:template_account) { create(:template_account, :email => 'template_account@example.com') }
  let(:valid_account)    { build(:test_account) }

  background do
    visit template_path(template_account.username, template_account.templates.first.slug)
  end

  scenario 'Unsigned user tries to demo a template', :js do
    visit template_path(template_account, template_account.templates.first)
    click_on 'Demo'
    fill_in 'Name',                  :with => valid_account.name
    fill_in 'Email',                 :with => valid_account.email
    fill_in 'Username',              :with => valid_account.username
    fill_in 'password',              :with => valid_account.password
    fill_in 'password_confirmation', :with => valid_account.password_confirmation
    click_button 'Sign up'
    current_path.should eq template_path(template_account, template_account.templates.first)
  end

  scenario 'Unsigned user tries to purchase a template', :js do
    click_on 'Purchase'
    fill_in 'Name',                  :with => valid_account.name
    fill_in 'Email',                 :with => valid_account.email
    fill_in 'Username',              :with => valid_account.username
    fill_in 'password',              :with => valid_account.password
    fill_in 'password_confirmation', :with => valid_account.password_confirmation
    click_button 'Sign up'
    current_path.should eq edit_account_path
    credit_card = fill_in_credit_card
    click_on 'Update'
    sleep_for(5, 'Hitting Stripe...')
    current_path.should eq template_path(template_account, template_account.templates.first)
  end
end
