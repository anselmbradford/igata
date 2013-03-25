require 'spec_helper'

def purchase_template(force_sleep = true)
  click_button 'Purchase'
  pending 'wait_until removed'
  wait_until do
    first('input[value="Confirm"]')
  end
  click_button 'Confirm'
  sleep_for(5, 'Hitting Stripe...') if force_sleep
end

def confirm_deploy(force_sleep = true)
  pending 'wait_until removed'
  wait_until 120 do
    visit current_url
    page.first('ul#deployed_templates li .app a')
  end
  page.find('ul#deployed_templates li .app a').click
  sleep_for(10, 'Confirming deploy...') if force_sleep
  page.should have_content 'Igata Test'
end

feature 'Store', :js, :git, :heroku, :resque do
  scenario 'Purchasing and deploying' do
    template_account = create(:template_account)
    template_account.templates.last.clone_repo
    sign_in_with(create(:test_account))
    click_link 'Test Template'
    purchase_template
    confirm_deploy
  end

  scenario 'Purchasing a template and verifying ownership' do
    template_account = create(:template_account)
    template_account.templates.last.clone_repo
    sign_in_with(create(:test_account))
    click_link 'Test Template'
    purchase_template
    click_link 'my purchases'
    click_link 'Test Template'
    confirm_deploy
  end

  scenario 'Deploying a free template' do
    template_account = create(:template_account, :templates => [build(:test_template, :developer_cost => 0, :name => 'Free Template')])
    template_account.templates.last.clone_repo
    sign_in_with(create(:other_account))
    click_link 'Free Template'
    confirm_deploy
  end

  scenario 'Attempting to buy a template with no credit card' do
    template_account = create(:template_account)
    template_account.templates.last.clone_repo
    sign_in_with(create(:other_account))
    click_link 'Test Template'
    purchase_template(false)
    fill_in_credit_card
    click_button 'Update'
    purchase_template
    confirm_deploy
  end

  scenario 'Deploying my own template' do
    template_account = sign_in_with(create(:template_account))
    template_account.templates.last.clone_repo
    click_link 'Test Template'
    confirm_deploy
  end
end
