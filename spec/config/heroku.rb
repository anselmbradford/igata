RSpec.configure do |config|
  config.after(:each, :heroku => true) do
    if current_account
      api_key = case current_account.email
                when 'test_account@igata.io'  then '88a8818dec81ca8f8b321551695fdd1487669795'
                when 'test_template@igata.io' then 'afb8990700cea3a8507781c6e4b89c40e0f7f08a'
                when 'other@igata.io'         then 'ad7fc2d9ea71316e2bdbf973d63e9d19b3b46089'
                end
      heroku = Heroku::API.new(:api_key => api_key)
      heroku.get_apps.body.each { |app| heroku.delete_app(app['name']) }
    end
  end
end
