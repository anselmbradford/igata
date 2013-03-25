RSpec.configure do |config|
  config.before(:each, :resque => true) do
    Resque.redis.flushdb
    Resque.inline = true
  end

  config.after(:each, :resque => true) do
    Resque.inline = false
  end
end
