require 'timecop'

RSpec.configure do |config|
  config.before(:suite) do
    Timecop.travel(DateTime.new(2012, 1, 1, 6, 30, 0, 0))
  end

  config.after(:suite) do
    Timecop.return
  end
end
