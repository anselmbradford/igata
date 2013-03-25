require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end

  at_exit do
    DatabaseCleaner.clean
  end
end
