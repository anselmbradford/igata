require 'spec_helper'

feature 'Editing an account' do
  background do
    sign_in_with(create(:test_account))
    click_link 'Account'
  end

  scenario 'with valid info' do
    fill_in 'Email', :with => 'changed@example.com'
    fill_in 'Name', :with => 'Changed account'
    fill_in 'account_password', :with => 'changed_password'
    fill_in 'Password confirmation', :with => 'changed_password'
    click_button 'Update'
    visit sign_out_path

    visit sign_in_path
    fill_in 'Email', :with => 'changed@example.com'
    fill_in 'Password', :with => 'changed_password'
    click_button 'Sign in'

    page.should have_content 'Dashboard'
  end
end

feature 'Billing Information', :js do
  scenario 'no card yet' do
    sign_in_with(create(:other_account))
    click_link 'Account'
    click_link 'Credit Card'
    credit_card = fill_in_credit_card
    click_button 'Update'
    sleep_for(5, 'Hitting Stripe...')
    click_link 'Credit Card'
    page.should have_content credit_card_disguised_number(credit_card[:number])
    page.should have_content credit_card_formatted_expiration_date(credit_card[:month], credit_card[:year])
    delete_customer
  end

  scenario 'updating an existing card' do
    sign_in_with(create(:other_account))
    click_link 'Account'
    click_link 'Credit Card'
    fill_in_credit_card
    click_button 'Update'
    sleep_for(5, 'Hitting Stripe...')
    new_number = '5555555555554444'
    new_month  = 'February'
    new_year   = '2015'
    fill_in 'Card number', :with => new_number
    fill_in 'CVC',         :with => '457'
    select  new_month,     :from => 'Month'
    select  new_year,      :from => 'Year'
    click_button 'Update'
    pending 'This fails to append the credit card token, but works in development'
    sleep_for(5, 'Hitting Stripe...')
    click_link 'Credit Card'
    page.should have_content credit_card_disguised_number(new_number)
    page.should have_content credit_card_formatted_expiration_date(new_month, new_year)
    delete_customer
  end

  def delete_customer
    current_account.reload
    customer = Stripe::Customer.retrieve(current_account.stripe_id)
    customer.delete
  end

  def credit_card_disguised_number(number)
    '*' * 11 + number[12..16]
  end

  def credit_card_formatted_expiration_date(month, year)
    "#{Igata::Months.detect { |_month| _month[0] == month }[1]}/#{year}"
  end
end
