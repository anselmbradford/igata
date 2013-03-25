FactoryGirl.define do
  factory :account do
    name                  'Test Account'
    username              'testuser'
    email                 'test@example.com'
    password              'password'
    password_confirmation 'password'
  end

  factory :test_account, :parent => :account do
    email     'test_account@igata.io'
    username  'test_account'
    stripe_id 'cus_a8vSsdx9wLekqS'
  end

  factory :template_account, :parent => :test_account do
    name      'Template Account'
    username  'template_account'
    email     'test_template@igata.io'
    stripe_id 'cus_KnzuNpTfaYA1Dd'
    templates { [FactoryGirl.build(:test_template)] } 
  end

  factory :other_account, :parent => :test_account do
    name      'Other Account'
    email     'other@igata.io'
    stripe_id nil
  end

  factory :test_template, :class => Template do
    name           'Test Template'
    developer_cost '10000'
    uri   { File.expand_path('vendor/repos/igata_test', Rails.root) }
    readme         "# Igata Test\n\nThis information is imported into Igata as the description.\n"
    slug           'test-template'
  end

  factory :redistogo_addon, :class => Addon do
    name                'redistogo:nano'
    description         'Redis To Go Nano'
    url                 'https://addons.heroku.com/addons/redistogo:nano'
    beta                false
    state               'public'
    cents               0
    price_units         'month'
    attachable          nil
    slug                nil
    consumes_dyno_hours nil
    plan_description    nil
    group_description   'Redistogo'
    selective           nil
  end

  factory :sendgrid_addon, :class => Addon do
    name                'sendgrid:starter'
    description         'Sendgrid Starter'
    url                 'https://addons.heroku.com/addons/sendgrid:start'
    beta                false
    state               'public'
    cents               0
    price_units         'month'
    attachable          nil
    slug                nil
    consumes_dyno_hours nil
    plan_description    nil
    group_description   'Sendgrid'
    selective           nil
  end
end
